###
#  for changes
#   see https://www.bigbinary.com/blog/rails-6-changed-activerecord-base-configurations-result-to-an-object
#
#    https://api.rubyonrails.org/v7.1.3.4/classes/ActiveRecord/DatabaseConfigurations.html


require 'active_record'

require 'logutils'


puts
puts ActiveRecord::VERSION::STRING
puts

  def connect( config={} )
    LogUtils::Logger.root.level = :debug
    logger = LogUtils::Logger.root


    if config.empty?   # use/try DATABASE_URL from environment

      logger.debug "ENV['DATBASE_URL'] - >#{ENV['DATABASE_URL']}<"

      db = URI.parse( ENV['DATABASE_URL'] || 'sqlite3:///pluto.db' )

      if db.scheme == 'postgres'
        config = {
          adapter:  'postgresql',
          host:     db.host,
          port:     db.port,
          username: db.user,
          password: db.password,
          database: db.path[1..-1],
          encoding: 'utf8'
        }
      else   # assume sqlite3
        config = {
          adapter:  db.scheme,       # sqlite3
          database: db.path[1..-1]   # pluto.db (NB: cut off leading /, thus 1..-1)
        }
      end
    end  # if config.nil?

    logger.info 'db settings:'
    logger.info config.pretty_inspect

    ### for dbbrowser and other tools add to ActiveRecord

    if ActiveRecord::Base.configurations.nil?   # todo/check: can this ever happen? remove?
       logger.debug "ActiveRecord configurations nil - set to empty hash"
       ActiveRecord::Base.configurations = {}  # make it an empty hash
    end

    ## todo/fix: remove debug? option - why? why not?
    ##    (just) use logger level eg. logger.debug
      logger.debug 'ar configurations (before):'
      logger.debug ActiveRecord::Base.configurations.pretty_inspect

      configs = ActiveRecord::Base.configurations

###
##  undefined method `[]' for #<ActiveRecord::DatabaseConfigurations:0x000001be2558fe78 @configurations=[]>
##     before 6+
##      pp configs['pluto']
##     configs['pluto'] = config

     pp configs.configs_for(env_name: 'pluto' )


      logger.debug 'ar configurations (after):'
      logger.debug ActiveRecord::Base.configurations.pretty_inspect



    ActiveRecord::Base.establish_connection( config )

    ## checkd default - possible?
    pp ActiveRecord::Base.connection_db_config
## results in:
#   #<ActiveRecord::DatabaseConfigurations::HashConfig:0x000001361c442d68
#     @configuration_hash={:adapter=>"sqlite3", :database=>":memory:"},
#     @env_name="default_env",
#     @name="primary">
#
#   note - autoadded env_name is default_env
#             and     name is primary


    logger.debug 'ar configurations (after establish_connection):'
    logger.debug ActiveRecord::Base.configurations.pretty_inspect

end # method connect



## try connect

config = { adapter: 'sqlite3',
           database: ':memory:'}
connect( config )


puts "bye"