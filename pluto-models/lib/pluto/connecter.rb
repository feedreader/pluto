# frozen_string_literal: true

module Pluto
  # DB Connecter / Connection Manager
  #   lets you establish connection

  class Connecter
    include LogUtils::Logging

    def initialize
      # do nothing for now
    end

    def debug? = Pluto.config.debug?

    def connect(config = {})
      if config.empty? # use/try DATABASE_URL from environment

        logger.debug "ENV['DATBASE_URL'] - >#{ENV['DATABASE_URL']}<"

        db = URI.parse(ENV['DATABASE_URL'] || 'sqlite3:///pluto.db')

        config = if db.scheme == 'postgres'
                   {
                     adapter: 'postgresql',
                     host: db.host,
                     port: db.port,
                     username: db.user,
                     password: db.password,
                     database: db.path[1..],
                     encoding: 'utf8'
                   }
                 else # assume sqlite3
                   {
                     adapter: db.scheme, # sqlite3
                     database: db.path[1..] # pluto.db (NB: cut off leading /, thus 1..-1)
                   }
                 end
      end

      logger.info 'db settings:'
      logger.info config.pretty_inspect

      ### for dbbrowser and other tools add to ActiveRecord

      if ActiveRecord::Base.configurations.nil? # todo/check: can this ever happen? remove?
        logger.debug 'ActiveRecord configurations nil - set to empty hash'
        ActiveRecord::Base.configurations = {} # make it an empty hash
      end

      ## todo/fix: remove debug? option - why? why not?
      ##    (just) use logger level eg. logger.debug
      if debug?
        logger.debug 'ar configurations (before):'
        logger.debug ActiveRecord::Base.configurations.pretty_inspect
      end

      configurations = ActiveRecord::Base.configurations.configs_for(env_name: 'pluto')
      configurations << config

      ActiveRecord::Base.configurations = configurations

      if debug?
        logger.debug 'ar configurations (after):'
        logger.debug ActiveRecord::Base.configurations.pretty_inspect
      end

      # for debugging - disable for production use
      ActiveRecord::Base.logger = Logger.new($stdout) if debug?

      ActiveRecord::Base.establish_connection(config)
    end
  end
end
