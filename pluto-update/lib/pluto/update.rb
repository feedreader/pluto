# encoding: utf-8

require 'opmlparser'


require 'pluto/models'
require 'pluto/feedfetcher'


# our own code
require 'pluto/update/version'   # Note: let version always go first
require 'pluto/update/feed_refresher'
require 'pluto/update/site_refresher'
require 'pluto/update/site_fetcher'



module Pluto

  def self.refresh_feeds   ## refresh == fetch+parse+update
    FeedRefresher.new.refresh_feeds
  end

  def self.refresh_sites  ## refresh == fetch+parse+update
    SiteRefresher.new.refresh_sites
  end

  ### convenience aliases w/ update_  -- use refresh (only) - why? why not??
  def self.update_feeds() refresh_feeds; end 
  def self.update_sites() refresh_sites; end

end  # module Pluto



# say hello
puts PlutoUpdate.banner   if $DEBUG || (defined?($RUBYLIBS_DEBUG) && $RUBYLIBS_DEBUG)
