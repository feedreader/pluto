# encoding: utf-8

module Pluto


# DB Connecter / Connection Manager
#   lets you establish connection

class Connecter

  include LogUtils::Logging



  def initialize
    # do nothing for now
  end

  def debug?()  Pluto.config.debug?;  end



  def connect( config={} )

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

    ##
    ### for dbbrowser and other tools add to ActiveRecord
    ##    todo/fix - find out how to add db config with code
    ##                  in ActiveRecord 6+ !!!!
    ##   for now (old) registration removed / commented out
    ##
    ## if ActiveRecord::Base.configurations.nil?   # todo/check: can this ever happen? remove?
    ##   logger.debug "ActiveRecord configurations nil - set to empty hash"
    ##   ActiveRecord::Base.configurations = {}  # make it an empty hash
    ##  end


    ## todo/fix: remove debug? option - why? why not?
    ##    (just) use logger level eg. logger.debug
    # if debug?
    #  logger.debug 'ar configurations (before):'
    #  logger.debug ActiveRecord::Base.configurations.pretty_inspect
    # end

    ## ActiveRecord::Base.configurations[ 'pluto' ] = config

    # if debug?
    #  logger.debug 'ar configurations (after):'
    #  logger.debug ActiveRecord::Base.configurations.pretty_inspect
    # end

    # for debugging - disable for production use
    if debug?
      ActiveRecord::Base.logger = Logger.new( STDOUT )
    end

    ActiveRecord::Base.establish_connection( config )
  end # method connect


end # class Connecter

end # module Pluto
