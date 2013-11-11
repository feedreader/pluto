###
# NB: for local testing run like:
#
# 1.9.x: ruby -Ilib lib/pakman.rb

# core and stdlibs

require 'yaml'
require 'json'
require 'uri'
require 'pp'
require 'optparse'
require 'fileutils'
require 'logger'
require 'date'
require 'digest/md5'


# 3rd party ruby gems/libs

require 'active_record'   ## todo: add sqlite3? etc.

require 'logutils'
require 'props'     # manage settings/env
require 'fetcher'   # fetch (download) files
require 'pakman'    # template pack manager
require 'feedutils'
require 'textutils'

require 'activityutils'

# our own code

require 'pluto/version'   # let version always get first
require 'pluto/schema'
require 'pluto/activerecord'

require 'pluto/models/activity'
require 'pluto/models/feed'
require 'pluto/models/item'
require 'pluto/models/site'
require 'pluto/models/subscription'
require 'pluto/models/utils'

require 'pluto/manifest_helpers'
require 'pluto/connecter'

require 'pluto/installer'
require 'pluto/fetcher'
require 'pluto/refresher'
require 'pluto/subscriber'
require 'pluto/updater'
require 'pluto/lister'
require 'pluto/formatter'

require 'pluto/cli/opts'     ## fix: make sure fetcher/updater etc. do not depend on cli/opts


module Pluto

  def self.banner
    ### todo: add RUBY_PATCHLEVEL or RUBY_PATCH_LEVEL  e.g. -p124
    "pluto/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.generator   # convenience alias for banner (matches HTML generator meta tag)
    banner
  end

  def self.root
    "#{File.expand_path( File.dirname(File.dirname(__FILE__)) )}"
  end

  def self.connect!( config=nil )  # convenience shortcut
    Connecter.new.connect!( config )
  end


  # todo: add alias update_site( config ) ??
  def self.update_subscriptions( config )
    Subscriber.new.update_subscriptions( config )
  end

  def self.update_feeds
    Refresher.new.update_feeds
  end

  def self.update_sites
    Refresher.new.update_sites
  end

  def self.load_tasks
    # load all builtin Rake tasks (from tasks/*rake)
    load 'pluto/tasks/env.rake'
    load 'pluto/tasks/setup.rake'
    load 'pluto/tasks/stats.rake'
    load 'pluto/tasks/update.rake'
  end


  def self.main
    require 'pluto/cli/main'
    ## Runner.new.run(ARGV) - old code
  end
  

end  # module Pluto



######
# todo - move to ext/array.rb or similar

class Array

  ## todo: check if there's already a builtin method for this
  #
  #  note:
  #   in rails ary.in_groups(3)  results in
  #          top-to-bottom, left-to-right.
  #  and not left-to-right first and than top-to-bottom.
  #
  #  rename to in_groups_vertical(3) ???

  def in_columns( cols )  # alias for convenience for chunks - needed? why? why not?
    chunks( cols )
  end

  def chunks( number_of_chunks )
    ## NB: use chunks - columns might be in use by ActiveRecord! 
    ###
    # e.g.
    #  [1,2,3,4,5,6,7,8,9,10].columns(3)
    #   becomes:
    #  [[1,4,7,10],
    #   [2,5,8],
    #   [3,6,9]]

    ## check/todo: make a copy of the array first??
    #  for now reference to original items get added to columns
    chunks = (1..number_of_chunks).collect { [] }
    each_with_index do |item,index|
      chunks[ index % number_of_chunks ] << item
    end
    chunks
  end

end


if __FILE__ == $0
  Pluto.main
else
  puts Pluto.banner       # say hello
end
