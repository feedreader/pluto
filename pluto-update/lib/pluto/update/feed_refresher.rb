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

  def debug=(value)  @debug = value;   end
  def debug?()       @debug || false;  end


  def refresh_feeds( opts={} )  # refresh (fetch+parse+update) all feeds
    if debug?
      ## turn on logging for sql too
      ActiveRecord::Base.logger = Logger.new( STDOUT )
      @worker.debug = true   # also pass along worker debug flag if set
    end

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
    if debug?
      ## turn on logging for sql too
      ActiveRecord::Base.logger = Logger.new( STDOUT )
      @worker.debug = true   # also pass along worker debug flag if set
    end

    # -- log update activity
    Activity.create!( text: "update feeds >#{site_key}<" )

    site = Site.find_by_key!( site_key )

    site.feeds.each do |feed|
      refresh_feed_worker( feed )
    end

  end # method refresh_feeds_for


private
  def refresh_feed_worker( feed_rec )
    feed_xml = @worker.fetch( feed_rec )

    # on error or if http-not modified etc. skip update/processing
    return  if feed_xml.nil?

    feed = FeedParser::Parser.parse( feed_xml )

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


    feed_rec.debug = debug? ? true : false    # pass along debug flag

    ## fix/todo: pass debug flag as opts - debug: true|false !!!!!!
    # fix/todo: find a better name - why? why not?? => use update_from_struct!
    feed_rec.deep_update_from_struct!( feed )

  end  # method refresh_feed_worker

end # class FeedRefresher

end # module Pluto
