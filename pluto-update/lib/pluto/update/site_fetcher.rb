# encoding: utf-8


module Pluto

class SiteFetcher

  include LogUtils::Logging
  include Models   # for easy convenience access for Activity etc.

  def initialize
    @worker  = Fetcher::Worker.new
  end

  def debug?()  Pluto.config.debug?;  end


  def fetch( site_rec )
    ####################################################
    # try smart http update; will update db records

    site_url = site_rec.url
    site_key = site_rec.key

    ### todo/fix: normalize/unifiy feed_url
    ##  - same in fetcher - use shared utitlity method or similar

    @worker.use_cache = true
    @worker.cache[ site_url ] = {
      'etag'          => site_rec.http_etag,
      'last-modified' => site_rec.http_last_modified
    }

    response = @worker.get( site_url )
    @worker.use_cache = false   # fix/todo: restore old use_cache setting instead of false

    site_fetched = Time.now

    ###
    # Note: Net::HTTP will NOT set encoding UTF-8 etc.
    # will be set to ASCII-8BIT == BINARY == Encoding Unknown; Raw Bytes Here
    # thus, set/force encoding to utf-8
    site_text = response.body.to_s
    site_text = site_text.force_encoding( Encoding::UTF_8 )

    if response.code == '304'  # not modified (conditional GET - e.g. using etag/last-modified)

      puts "OK - fetching site '#{site_key}' - HTTP status #{response.code} #{response.message}"
      puts "no change; request returns not modified (304); skipping parsing site config"
      return nil   # no updates available; nothing to do
 
    elsif response.code != '200'   # note Net::HTTP response.code is a string in ruby

      puts "*** error: fetching site '#{site_key}' - HTTP status #{response.code} #{response.message}"

      site_attribs = {
        http_code:          response.code.to_i,
        http_server:        response.header[ 'server' ],
        http_etag:          nil,
        http_last_modified: nil,
        fetched:            site_fetched
      }
      site_rec.update!( site_attribs )

      ## add log error activity -- in future add to error log - better - why? why not?
      Activity.create!( text: "*** error: fetching site '#{site_key}' - HTTP status #{response.code} #{response.message}" )

      return nil  #  sorry; no feed for parsing available
    else
      # assume 200; continue w/ processing
    end

    puts "OK - fetching site '#{site_key}' - HTTP status #{response.code} #{response.message}"

    site_attribs = {
      http_code:          response.code.to_i,
      http_server:        response.header[ 'server' ],
      http_etag:          response.header[ 'etag' ],
      http_last_modified: response.header[ 'last-modified' ], ## note: last_modified header gets stored as plain text (not datetime)
      fetched:            site_fetched
    }

    ## if debug?
      puts "http header - server: #{response.header['server']} - #{response.header['server'].class.name}"
      puts "http header - etag: #{response.header['etag']} - #{response.header['etag'].class.name}"
      puts "http header - last-modified: #{response.header['last-modified']} - #{response.header['last-modified'].class.name}"
    ## end

    site_rec.update!( site_attribs )


    ## logger.debug "site_text:"
    ## logger.debug site_text[ 0..300 ] # get first 300 chars

    site_text
  end

end # class SiteFetcher

end # module Pluto
