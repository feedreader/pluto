# encoding: utf-8


module Pluto

#######
# note: refresh
#  refresh will fetch site subscriptions, parse and than update the site subscriptions
#    (e.g. update is just one operation of refresh)


class SiteRefresher

  include LogUtils::Logging
  include Models

  def initialize
    @worker  = SiteFetcher.new
  end

  def debug=(value)  @debug = value;   end
  def debug?()       @debug || false;  end

  def refresh_sites( opts={} )  # refresh (fetch+parse+update) all site configs
    if debug?
      ## turn on logging for sql too
      ActiveRecord::Base.logger = Logger.new( STDOUT )
      @worker.debug = true   # also pass along worker debug flag if set
    end

    start_time = Time.now
    Activity.create!( text: "start update sites (#{Site.count})" )

    #### - hack - use order(:id) instead of .all - avoids rails/activerecord 4 warnings
    Site.order(:id).each do |site|
      refresh_site_worker( site )  if site.url.present?  # note: only update if (source) url present
    end

    total_secs = Time.now - start_time
    Activity.create!( text: "done update sites (#{Site.count}) in #{total_secs}s" )
  end


private
  def refresh_site_worker( site_rec )
    site_text = @worker.fetch( site_rec )

    # on error or if http-not modified etc. skip update/processing
    return  if site_text.nil?

    site_config = INI.load( site_text )

    ### site_rec.debug = debug? ? true : false    # pass along debug flag
    site_rec.deep_update_from_hash!( site_config )
  end

end # class SiteRefresher

end # module Pluto

