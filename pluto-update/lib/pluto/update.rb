# encoding: utf-8


require 'pluto/models'
require 'pluto/feedfetcher'


# more 3rd party gems
require 'fetcher'    # fetch (text) documents
require 'preproc'    # include preprocessor


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

### convenience alias w/ update_  -- use refresh (only) - why? why not??
  def self.update_feeds
    FeedRefresher.new.refresh_feeds
  end

  def self.update_sites
    SiteRefresher.new.refresh_sites
  end

end  # module Pluto



# say hello
puts PlutoUpdate.banner   if $DEBUG || (defined?($RUBYLIBS_DEBUG) && $RUBYLIBS_DEBUG)
