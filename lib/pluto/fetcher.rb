module Pluto


class Fetcher

  include LogUtils::Logging

  def initialize
    @worker  = ::Fetcher::Worker.new
  end

  def debug=(value)  @debug = value;   end
  def debug?()       @debug || false;  end


  def fetch_feed( url )
    response = @worker.get( url )

    ## if debug?
      puts "http status #{response.code} #{response.message}"

      puts "http header - server: #{response.header['server']} - #{response.header['server'].class.name}"
      puts "http header - etag: #{response.header['etag']} - #{response.header['etag'].class.name}"
      puts "http header - last-modified: #{response.header['last-modified']} - #{response.header['last-modified'].class.name}"
    ## end

    xml = response.body

    ###
    # NB: Net::HTTP will NOT set encoding UTF-8 etc.
    # will mostly be ASCII
    # - try to change encoding to UTF-8 ourselves
    logger.debug "xml.encoding.name (before): #{xml.encoding.name}"

    #####
    # NB: ASCII-8BIT == BINARY == Encoding Unknown; Raw Bytes Here

    ## NB:
    # for now "hardcoded" to utf8 - what else can we do?
    # - note: force_encoding will NOT change the chars only change the assumed encoding w/o translation
    xml = xml.force_encoding( Encoding::UTF_8 )
    logger.debug "xml.encoding.name (after): #{xml.encoding.name}"      

    xml
  end


  def feed_by_rec( feed_rec )
    # simple feed fetcher; use for debugging (only/mostly)
    #  -- will NOT change db records in any way

    feed_url = feed_rec.feed_url
    feed_key = feed_rec.key

    feed_xml = fetch_feed( feed_url )

    logger.debug "feed_xml:"
    logger.debug feed_xml[ 0..500 ] # get first 500 chars

    #  if opts.verbose?  # also write a copy to disk
    if debug?
      logger.debug "saving feed to >./#{feed_key}.xml<..."
      File.open( "./#{feed_key}.xml", 'w' ) do |f|
        f.write( feed_xml )
      end
    end
      
    puts "Before parsing feed >#{feed_key}<..."

    ## fix/todo: check for feed.nil?   -> error parsing!!!
    #    or throw exception
    feed = FeedUtils::Parser.parse( feed_xml )
  end


  def feed_by_rec_if_modified( feed_rec )   # try smart http update; will update db records
    feed_url = feed_rec.feed_url
    feed_key = feed_rec.key

    ### todo/fix:
    ##  add if available http_etag  machinery for smarter updates
    ##    and http_last_modified headers
    ##    and brute force body_old == body_new   etc.

    ### todo/fix: normalize/unifiy feed_url
    ##  - same in fetcher - use shared utitlity method or similar

    @worker.use_cache = true
    @worker.cache[ feed_url ] = {
      'etag'          => feed_rec.http_etag,
      'last-modified' => feed_rec.http_last_modified
    }

    ### fix bug in fetcher - do NOT use request_uri use uri.to
    ## - add request_uri entry to (e.g. w/o host etc.)
    ## - remove code here once fixed in fetcher
    @worker.cache[ URI.parse( feed_url ).request_uri ] = {
      'etag'          => feed_rec.http_etag,
      'last-modified' => feed_rec.http_last_modified
    }


    response = @worker.get( feed_url )
    @worker.use_cache = false   # fix/todo: restore old use_cache setting instead of false

    if response.code == '304'  # not modified (conditional GET - e.g. using etag/last-modified)
      puts "OK - fetching feed '#{feed_key}' - HTTP status #{response.code} #{response.message}"
      puts "no change; request returns not modified (304); skipping parsing feed"
      return nil   # no updates available; nothing to do
    end

    feed_fetched = Time.now

    if response.code != '200'   # note Net::HTTP response.code is a string in ruby

      puts "*** error: fetching feed '#{feed_key}' - HTTP status #{response.code} #{response.message}"
      
      feed_attribs = {
        http_code:          response.code.to_i,
        http_server:        response.header[ 'server' ],
        http_etag:          nil,
        http_last_modified: nil,
        body:               nil,
        md5:                nil,
        fetched:            feed_fetched 
      }
      feed_rec.update_attributes!( feed_attribs )
      return nil  #  sorry; no feed for parsing available
    end

    puts "OK - fetching feed '#{feed_key}' - HTTP status #{response.code} #{response.message}"

    feed_xml = response.body
    ###
    # NB: Net::HTTP will NOT set encoding UTF-8 etc.
    # will mostly be ASCII
    # - try to change encoding to UTF-8 ourselves
    logger.debug "feed_xml.encoding.name (before): #{feed_xml.encoding.name}"

    #####
    # NB: ASCII-8BIT == BINARY == Encoding Unknown; Raw Bytes Here

    ## NB:
    # for now "hardcoded" to utf8 - what else can we do?
    # - note: force_encoding will NOT change the chars only change the assumed encoding w/o translation
    feed_xml = feed_xml.force_encoding( Encoding::UTF_8 )
    logger.debug "feed_xml.encoding.name (after): #{feed_xml.encoding.name}"

    ## check for md5 hash for response.body

    last_feed_md5 = feed_rec.md5
    feed_md5 = Digest::MD5.hexdigest( feed_xml )
    
    if last_feed_md5 && last_feed_md5 == feed_md5
      # not all servers handle conditional gets, so while not much can be
      # done about the bandwidth, but if the response body is identical
      # the downstream processing (parsing, caching, ...) can be avoided.
      #  - thanks to planet mars -fido.rb for the idea, cheers.
      
      puts "no change; md5 digests match; skipping parsing feed"
      return nil   # no updates available; nothing to do
    end

    feed_attribs = {
      http_code:          response.code.to_i,
      http_server:        response.header[ 'server' ],
      http_etag:          response.header[ 'etag' ],
      http_last_modified: response.header[ 'last-modified' ], ## note: last_modified header gets stored as plain text (not datetime)
      body:               feed_xml,
      md5:                feed_md5,
      fetched:            feed_fetched
    }

    ## if debug?
      puts "http header - server: #{response.header['server']} - #{response.header['server'].class.name}"
      puts "http header - etag: #{response.header['etag']} - #{response.header['etag'].class.name}"
      puts "http header - last-modified: #{response.header['last-modified']} - #{response.header['last-modified'].class.name}"
    ## end

    feed_rec.update_attributes!( feed_attribs )

    logger.debug "feed_xml:"
    logger.debug feed_xml[ 0..300 ] # get first 300 chars
      
    puts "Before parsing feed >#{feed_key}<..."

    ### move to feedutils
    ### logger.debug "using stdlib RSS::VERSION #{RSS::VERSION}"

    ## fix/todo: check for feed.nil?   -> error parsing!!!
    #    or throw exception
    feed = FeedUtils::Parser.parse( feed_xml )
  end
  
end # class Fetcher

end # module Pluto
