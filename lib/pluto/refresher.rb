module Pluto

class Refresher

  include LogUtils::Logging

  include Models

  def initialize
    @worker  = Fetcher.new
  end

  def debug=(value)  @debug = value;   end
  def debug?()       @debug || false;  end


  def update_sites( opts={} )  # update all site configs
    if debug?
      ## turn on logging for sql too
      ActiveRecord::Base.logger = Logger.new( STDOUT )
      @worker.debug = true   # also pass along worker debug flag if set
    end

    # -- log update activity
    Activity.create!( text: "update sites (#{Site.count})" )

    #### - hack - use order(:id) instead of .all - avoids rails/activerecord 4 warnings

    Site.order(:id).each do |site|
      update_site_worker( site )  if site.url.present?  # note: only update if (source) url present
    end
  end


  def update_feeds( opts={} )  # update all feeds
    if debug?
      ## turn on logging for sql too
      ActiveRecord::Base.logger = Logger.new( STDOUT )
      @worker.debug = true   # also pass along worker debug flag if set
    end

    # -- log update activity
    Activity.create!( text: "update feeds (#{Feed.count})" )

    #### - hack - use order(:id) instead of .all - avoids rails/activerecord 4 warnings

    Feed.order(:id).each do |feed|
      update_feed_worker( feed )
    end
  end


  def update_feeds_for( site_key, opts={} )
    if debug?
      ## turn on logging for sql too
      ActiveRecord::Base.logger = Logger.new( STDOUT )
      @worker.debug = true   # also pass along worker debug flag if set
    end

    # -- log update activity
    Activity.create!( text: "update feeds >#{site_key}<" )

    site = Site.find_by_key!( site_key )

    site.feeds.each do |feed|
      update_feed_worker( feed )
    end

  end # method update_feeds


private
  def update_site_worker( site_rec )
    site_config = @worker.site_by_rec_if_modified( site_rec )
  
    # on error or if http-not modified etc. skip update/processing
    return  if site_config.nil?

    subscriber = Subscriber.new
    subscriber.debug = debug? ? true : false    # pass along debug flag

    site_key = site_rec.key
    subscriber.update_subscriptions_for( site_key, site_config )
  end


  def update_feed_worker( feed_rec )
    feed = @worker.feed_by_rec_if_modified( feed_rec )
      
    # on error or if http-not modified etc. skip update/processing
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


    feed_rec.debug = debug? ? true : false    # pass along debug flag
    ## fix/todo: pass debug flag as opts - debug: true|false !!!!!!
    feed_rec.save_from_struct!( feed )  # todo: find a better name - why? why not??


    #  update  cached value last published for item
    last_item_rec = feed_rec.items.latest.limit(1).first  # note limit(1) will return relation/arrar - use first to get first element or nil from ary
    if last_item_rec.present?
      if last_item_rec.published?
        feed_rec.update_attributes!( last_published: last_item_rec.published )
      else # try touched
        feed_rec.update_attributes!( last_published: last_item_rec.touched )
      end
    end
  end  # method update_feed_worker

end # class Refresher

end # module Pluto
