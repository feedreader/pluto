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

  def debug?()  Pluto.config.debug?;  end


  def refresh_sites( opts={} )  # refresh (fetch+parse+update) all site configs
 
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

    site_rec.deep_update_from_hash!( site_config )
  end

end # class SiteRefresher

end # module Pluto
