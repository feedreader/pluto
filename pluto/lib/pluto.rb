# encoding: utf-8

require 'pluto/models'
require 'pluto/update'
require 'pluto/merge'
require 'pluto/tasks'



# our own code
require 'pluto/cli/version'   # note: let version always get first
require 'pluto/cli/opts'     ## fix: make sure fetcher/updater etc. do not depend on cli/opts
require 'pluto/cli/sysinfo'
require 'pluto/cli/updater'
require 'pluto/cli/version_check'


version_check!( 
  ['pakman',            '1.1.0', Pakman::VERSION], 
  ['fetcher',           '0.4.5', Fetcher::VERSION],
  ['feedparser',        '2.1.2', FeedParser::VERSION],
  ['feedfilter',        '1.1.1', FeedFilter::VERSION],
  ['textutils',         '1.4.0', TextUtils::VERSION],
  ['logutils',          '0.6.1', LogKernel::VERSION],
  ['props',             '1.2.0', Props::VERSION],

  ['pluto-models',      '1.5.4', Pluto::VERSION], 
  ['pluto-update',      '1.6.3', PlutoUpdate::VERSION],
  ['pluto-feedfetcher', '0.1.4', PlutoFeedFetcher::VERSION],
  ['pluto-merge',       '1.1.0', PlutoMerge::VERSION] )



module Pluto

  def self.main
    require 'pluto/cli/main'
    ## Runner.new.run(ARGV) - old code
  end

end  # module Pluto


Pluto.main   if __FILE__ == $0
