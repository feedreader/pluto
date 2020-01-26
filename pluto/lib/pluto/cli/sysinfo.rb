# encoding: utf-8

module Pluto

class SysInfo

  ## todo/fix:
  ##   pass in/use config (props)

  def initialize( opts )
    @opts = opts
  end

  attr_reader :opts


  def dump
  puts <<TXT

#{PlutoCli.banner}

Gems versions:
  - pakman #{Pakman::VERSION}
  - fetcher #{Fetcher::VERSION}
  - feedparser #{FeedParser::VERSION}
  - feedfilter #{FeedFilter::VERSION}
  - textutils #{TextUtils::VERSION}
  - logutils #{LogKernel::VERSION}
  - props #{Props::VERSION}

  - pluto #{PlutoCli::VERSION}
  - pluto-models #{Pluto::VERSION}
  - pluto-update #{PlutoUpdate::VERSION}
  - pluto-feedfetcher #{PlutoFeedFetcher::VERSION}
  - pluto-merge #{PlutoMerge::VERSION}
  - pluto-tasks #{PlutoTasks::VERSION}

    Env home: #{Env.home}
Pluto config: #{opts.config_path}
  Pluto root: #{Pluto.root}

TXT

  # dump Pluto settings
  # config.dump
  # puts


  ## todo: add more gem version info
  # todo: add  logutils version
  #       add  gli2     version
  end

end # class SysInfo

end  # module Pluto
