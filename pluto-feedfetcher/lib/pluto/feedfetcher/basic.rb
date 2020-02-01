# encoding: utf-8

module Pluto

class FeedFetcherBasic

  include LogUtils::Logging
  include Models   # for easy convenience access for Activity etc.

  def initialize
    @worker  = Fetcher::Worker.new
  end

  def debug?()  Pluto.config.debug?;  end


  def fetch( feed_rec )
    # simple/basic feed fetcher; use for debugging (only/mostly)
    #  -- Note: will NOT change db records in any way

    feed_url = feed_rec.feed_url
    feed_key = feed_rec.key

    feed_xml = fix_me_fetch_utf8( feed_url )

    logger.debug "feed_xml:"
    logger.debug feed_xml[ 0..500 ] # get first 500 chars


####  todo/fix: make it generic - move out of this method (re)use - for all fetcher??
    #  if opts.verbose?  # also write a copy to disk
    if debug?
      logger.debug "saving feed to >./#{feed_key}.xml<..."
      File.open( "./#{feed_key}.xml", 'w' ) do |f|
        f.write( feed_xml )
      end
    end



    ### todo/fix:
    ###  return feed_xml !!! - move FeedUtils::Parser.parse to update or someting !!!

    logger.info "Before parsing feed >#{feed_key}<..."


    feed_xml

    ## fix/todo: check for feed.nil?   -> error parsing!!!
    #    or throw exception
    # feed = FeedUtils::Parser.parse( feed_xml )
    # feed
  end


###########
#  todo/fix: use "standard" fetch method e.g. Fetcher.read_utf8!() - clean up/remove (duplicate) here??
private
  def fix_me_fetch_utf8( url )
    response = @worker.get( url )

    ## if debug?
      logger.debug "http status #{response.code} #{response.message}"

      logger.debug "http header - server: #{response.header['server']} - #{response.header['server'].class.name}"
      logger.debug "http header - etag: #{response.header['etag']} - #{response.header['etag'].class.name}"
      logger.debug "http header - last-modified: #{response.header['last-modified']} - #{response.header['last-modified'].class.name}"
    ## end

    xml = response.body

    ###
    # Note: Net::HTTP will NOT set encoding UTF-8 etc.
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

end # class FeedFetcherBasic

end # module Pluto
