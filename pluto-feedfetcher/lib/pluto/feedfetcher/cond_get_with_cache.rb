# encoding: utf-8

module Pluto

class FeedFetcherCondGetWithCache

  include LogUtils::Logging
  include Models   # for easy convenience access for Activity etc.

  def initialize
    @worker  = Fetcher::Worker.new
  end

  def debug?()  Pluto.config.debug?;  end


  def fetch( feed_rec )
    #############
    # try smart http update; will update db records

    feed_url = feed_rec.feed_url
    feed_key = feed_rec.key

    ### todo/fix: normalize/unifiy feed_url
    ##  - same in fetcher - use shared utitlity method or similar

    @worker.use_cache = true
    @worker.cache[ feed_url ] = {
      'etag'          => feed_rec.http_etag,
      'last-modified' => feed_rec.http_last_modified
    }

    begin
      response = @worker.get( feed_url )

     ## todo/fix: add a retry for open timeout - why? why not?
     ##  When you run into Net::OpenTimeout, you should handle it 
     ## by retrying the request a few times, 
     ## or giving up and showing a helpful error to the user.
     ## --  <https://www.exceptionalcreatures.com/bestiary/Net/OpenTimeout.html>

    rescue OpenSSL::SSL::SSLError,
           Net::OpenTimeout,
           Net::ReadTimeout, 
           SocketError, 
           SystemCallError => e

      ## catch socket error for unknown domain names (e.g. pragdave.blogs.pragprog.com)
      ###  will result in SocketError -- getaddrinfo: Name or service not known
      logger.error "*** error: fetching feed '#{feed_key}' - [#{e.class.name}] #{e.to_s}"
      Activity.create!( text: "*** error: fetching feed '#{feed_key}' - [#{e.class.name}] #{e.to_s}" )

      ### todo/fix: update feed rec in db
      @worker.use_cache = false   # fix/todo: restore old use_cache setting instead of false
      return nil
    end

    @worker.use_cache = false   # fix/todo: restore old use_cache setting instead of false

    if response.code == '304'  # not modified (conditional GET - e.g. using etag/last-modified)
      logger.info "OK - fetching feed '#{feed_key}' - HTTP status #{response.code} #{response.message}"
      logger.info "no change; request returns not modified (304); skipping parsing feed"
      return nil   # no updates available; nothing to do
    end

    feed_fetched = Time.now

    if response.code != '200'   # note Net::HTTP response.code is a string in ruby

      logger.error "*** error: fetching feed '#{feed_key}' - HTTP status #{response.code} #{response.message}"

      feed_attribs = {
        http_code:          response.code.to_i,
        http_server:        response.header[ 'server' ],
        http_etag:          nil,
        http_last_modified: nil,
        body:               nil,
        md5:                nil,
        fetched:            feed_fetched
      }
      feed_rec.update!( feed_attribs )

      ## add log error activity -- in future add to error log - better - why? why not?
      Activity.create!( text: "*** error: fetching feed '#{feed_key}' - HTTP status #{response.code} #{response.message}" )

      return nil  #  sorry; no feed for parsing available
    end

    logger.info "OK - fetching feed '#{feed_key}' - HTTP status #{response.code} #{response.message}"

    feed_xml = response.body
    ###
    # Note: Net::HTTP will NOT set encoding UTF-8 etc.
    # will mostly be ASCII
    # - try to change encoding to UTF-8 ourselves
    logger.debug "feed_xml.encoding.name (before): #{feed_xml.encoding.name}"


    #####
    # NB: ASCII-8BIT == BINARY == Encoding Unknown; Raw Bytes Here

    # try Converting ASCII-8BIT to UTF-8 based domain-specific guesses
    begin
      # Try it as UTF-8 directly
      #   Note: make a copy/dup - otherwise convert fails (because string is already changed/corrupted)
      feed_xml_cleaned = feed_xml.dup.force_encoding( Encoding::UTF_8 )
      unless feed_xml_cleaned.valid_encoding?

         logger.warn "*** warn: feed '#{feed_key}' charset encoding not valid utf8 - trying latin1"
         Activity.create!( text: "*** warn: feed '#{feed_key}' charset encoding not valid utf8 - trying latin1" )
         # Some of it might be old Windows code page
         # -- (Windows Code Page CP1252 is ISO_8859_1 is Latin-1 - check ??)

         # tell ruby the encoding
         # encode to utf-8
         ## use all in code encode ?? e.g. feed_xml_cleaned = feed_xml.encode( Encoding::UTF_8, Encoding::ISO_8859_1 )
         feed_xml_cleaned = feed_xml.dup.force_encoding( Encoding::ISO_8859_1 ).encode( Encoding::UTF_8 )
      end
      feed_xml = feed_xml_cleaned
    rescue EncodingError => e
      logger.warn "*** warn: feed '#{feed_key}' charset encoding to utf8 failed; throwing out invalid bits - #{e.to_s}"
      Activity.create!( text: "*** warn: feed '#{feed_key}' charset encoding to utf8 failed; throwing out invalid bits - #{e.to_s}" )

      # Force it to UTF-8, throwing out invalid bits
      ## todo: check options - add ?? or something to mark invalid chars ???
      feed_xml.encode!( Encoding::UTF_8, :invalid => :replace, :undef => :replace )
    end

    ## NB:
    # for now "hardcoded" to utf8 - what else can we do?
    # - note: force_encoding will NOT change the chars only change the assumed encoding w/o translation
    ### old "simple" version
    ## feed_xml = feed_xml.force_encoding( Encoding::UTF_8 )


    logger.debug "feed_xml.encoding.name (after): #{feed_xml.encoding.name}"

    ## check for md5 hash for response.body

    last_feed_md5 = feed_rec.md5
    feed_md5 = Digest::MD5.hexdigest( feed_xml )

    if last_feed_md5 && last_feed_md5 == feed_md5
      # not all servers handle conditional gets, so while not much can be
      # done about the bandwidth, but if the response body is identical
      # the downstream processing (parsing, caching, ...) can be avoided.
      #  - thanks to planet mars -fido.rb for the idea, cheers.

      logger.info "no change; md5 digests match; skipping parsing feed"
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
      logger.debug "http header - server: #{response.header['server']} - #{response.header['server'].class.name}"
      logger.debug "http header - etag: #{response.header['etag']} - #{response.header['etag'].class.name}"
      logger.debug "http header - last-modified: #{response.header['last-modified']} - #{response.header['last-modified'].class.name}"
    ## end

    ### note: might crash w/ encoding errors when saving in postgress
    ##  e.g. PG::CharacterNotInRepertoire: ERROR: ...
    ##  catch error, log it and stop for now
    #
    #  in the future check for different charset than utf-8 ?? possible?? how to deal with non-utf8 charsets??

    begin
      feed_rec.update!( feed_attribs )
    rescue Exception => e
      # log db error; and continue
      logger.error "*** error: updating feed database record '#{feed_key}' - #{e.to_s}"
      Activity.create!( text: "*** error: updating feed database record '#{feed_key}' - #{e.to_s}" )
      return nil  #  sorry; corrupt feed; parsing not possible; fix char encoding - make it an option in config??
    end


    logger.debug "feed_xml:"
    logger.debug feed_xml[ 0..300 ] # get first 300 chars

    logger.info "Before parsing feed >#{feed_key}<..."

    ### move to feedutils
    ### logger.debug "using stdlib RSS::VERSION #{RSS::VERSION}"


    ### todo/fix:
    ###  return feed_xml !!! - move FeedUtils::Parser.parse to update or someting !!!

    feed_xml
    ## fix/todo: check for feed.nil?   -> error parsing!!!
    #    or throw exception
    ## feed = FeedUtils::Parser.parse( feed_xml )
    ## feed
  end


end # class FeedFetcherCondGetWithCache

end # module Pluto
