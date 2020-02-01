# encoding: utf-8


module Pluto

#######
# note: refresh
#  refresh will fetch feeds, parse feeds and than update feeds
#    (e.g. update is just one operation of refresh)

class FeedRefresher

  include LogUtils::Logging
  include Models

  def initialize
    ## @worker = FeedFetcherBasic.new  ## -- simple fetch (strategy); no cache, no cond get etc.
    @worker  = FeedFetcherCondGetWithCache.new
  end

  def debug?()  Pluto.config.debug?;  end



  def refresh_feeds( opts={} )  # refresh (fetch+parse+update) all feeds
  
    start_time = Time.now
    Activity.create!( text: "start update feeds (#{Feed.count})" )

    #### - hack - use order(:id) instead of .all - avoids rails/activerecord 4 warnings
    Feed.order(:id).each do |feed|
      refresh_feed_worker( feed )
      ### todo/fix: add catch exception in loop and log to activity log and continue w/ next feed
    end

    total_secs = Time.now - start_time
    Activity.create!( text: "done update feeds (#{Feed.count}) in #{total_secs}s" )
  end


  def refresh_feeds_for( site_key, opts={} ) # refresh (fetch+parse+update) feeds for site
  
    # -- log update activity
    Activity.create!( text: "update feeds >#{site_key}<" )

    site = Site.find_by_key!( site_key )

    site.feeds.each do |feed|
      refresh_feed_worker( feed )
    end

  end # method refresh_feeds_for


private
  def refresh_feed_worker( feed_rec )
    text = @worker.fetch( feed_rec )

    # on error or if http-not modified etc. skip update/processing
    return  if text.nil?

    parser = FeedParser::Parser.new( text )
    feed = if parser.is_xml?
             parser.parse_xml
           elsif parser.is_json?    ## support JSON Feed
             parser.parse_json
             ##  note: reading/parsing microformat is for now optional
             ##    microformats gem requires nokogiri
             ##       nokogiri (uses libxml c-extensions) makes it hard to install (sometime)
             ##       thus, if you want to use it, please opt-in to keep the install "light"
           elsif defined?( Microformats ) && parser.is_microformats?
             parser.parse_microformats
           else  ## unknown feed format - return error; do NOT fallback assuming xml for now
             logger.error "*** error: unknown feed format (is XML or JSON?) for '#{feed_rec.key}' - #{feed_rec.feed_url} starting with: #{text.lstrip[0..20]}"
             Activity.create!( text: "*** error: unknown feed format (is XML or JSON?) for '#{feed_rec.key}' - #{feed_rec.feed_url} starting with: #{text.lstrip[0..20]}" )
             
             nil  ## note: return nil for no feed / processing error
          end

    return  if feed.nil?


    ## fix/todo: reload feed_red   - fetched date updated etc.
    ##  check if needed for access to fetched date

    ## todo/check: move feed_rec update to the end (after item updates??)

    # update feed attribs e.g.
    #    generator
    #    published_at,built_at,touched_at,fetched_at
    #    summary,title2

    ## fix:
    ## weird rss exception error on windows w/ dates
    #  e.g. /lib/ruby/1.9.1/rss/rss.rb:37:in `w3cdtf': wrong number of arguments (1 for 0) (ArgumentError)
    #
    #  move to_datetime to feedutils!! if it works
    ##   todo: move this comments to feedutils??

    # fix/todo: find a better name - why? why not?? => use update_from_struct!
    feed_rec.deep_update_from_struct!( feed )

  end  # method refresh_feed_worker

end # class FeedRefresher

end # module Pluto
