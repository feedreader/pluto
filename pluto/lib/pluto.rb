# encoding: utf-8

require 'pluto/models'
require 'pluto/update'
require 'pluto/merge'
require 'pluto/tasks'


# 3rd party ruby gems/libs


# our own code

require 'pluto/cli/version'   # note: let version always get first
require 'pluto/cli/opts'     ## fix: make sure fetcher/updater etc. do not depend on cli/opts
require 'pluto/cli/sysinfo'
require 'pluto/cli/updater'



module Pluto

  def self.main
    require 'pluto/cli/main'
    ## Runner.new.run(ARGV) - old code
  end

end  # module Pluto


Pluto.main   if __FILE__ == $0
