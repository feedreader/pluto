# encoding: utf-8

# core and stdlibs

require 'yaml'
require 'json'
require 'uri'
require 'pp'
require 'fileutils'
require 'date'
require 'time'
require 'digest/md5'

require 'logger'             # Note: use for ActiveRecord::Base.logger = Logger.new( STDOUT ) for now


# 3rd party ruby gems/libs

require 'active_record'

require 'props'     # manage settings/env
require 'logutils'
require 'textutils'
require 'feedparser'
require 'feedfilter'
require 'date/formatter'


## add more activerecords addons/utils
require 'activerecord/utils'     # add macros e.g. read_attr_w_fallbacks etc.
require 'activityutils'
require 'props/activerecord'
require 'logutils/activerecord'


# our own code

require 'pluto/version'   # note: let version always get first
require 'pluto/config'
require 'pluto/schema'

require 'pluto/models/forward'
require 'pluto/models/feed'
require 'pluto/models/item'
require 'pluto/models/site'
require 'pluto/models/subscription'
require 'pluto/models/utils'

require 'pluto/connecter'


module Pluto

  def self.create
    CreateDb.new.up
    ConfDb::Model::Prop.create!( key: 'db.schema.planet.version', value: VERSION )
  end

  def self.create_all
    LogDb.create # add logs table
    ConfDb.create # add props table
    ActivityDb::CreateDb.new.up    # todo/check - use ActivityDb.create if exists???
    Pluto.create
  end


  def self.auto_migrate!
    # first time? - auto-run db migratation, that is, create db tables
    unless LogDb::Model::Log.table_exists?
      LogDb.create # add logs table
    end

    unless ConfDb::Model::Prop.table_exists?
      ConfDb.create # add props table
    end

    ## fix: change to Model from Models
    unless ActivityDb::Models::Activity.table_exists?
      ActivityDb::CreateDb.new.up    # todo/check - use ActivityDb.create if exists???
    end

    unless Model::Feed.table_exists?
      Pluto.create
    end
  end # method auto_migrate!



  def self.connect( config={} )  # convenience shortcut without (w/o) automigrate
    Connecter.new.connect( config )
  end

  def self.connect!( config={} )  # convenience shortcut w/ automigrate
    Pluto.connect( config )
    Pluto.auto_migrate!
  end


  def self.setup_in_memory_db
    # Database Setup & Config
    ActiveRecord::Base.logger = Logger.new( STDOUT )
    ## ActiveRecord::Base.colorize_logging = false - no longer exists - check new api/config setting?

    Pluto.connect( adapter: 'sqlite3',
                   database: ':memory:' )

    ## build schema
    Pluto.create_all
  end # setup_in_memory_dd


  #########################################
  ## let's put test configuration in its own namespace / module
  class Test    ## todo/check: works with module too? use a module - why? why not?

    ####
    #  todo/fix:  find a better way to configure shared test datasets - why? why not?
    #    note: use one-up (..) directory for now as default - why? why not?
    def self.data_dir()        @data_dir ||= '../test'; end
    def self.data_dir=( path ) @data_dir = path; end
  end # class Test

end  # module Pluto




# say hello
puts Pluto.banner   if $DEBUG || (defined?($RUBYLIBS_DEBUG) && $RUBYLIBS_DEBUG)
