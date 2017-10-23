# encoding: utf-8

module Pluto


# DB Connecter / Connection Manager
#   lets you establish connection

class Connecter

  include LogUtils::Logging

  def initialize
    # do nothing for now
  end


  def debug=(value) @debug = value; end
  def debug?()      @debug || false; end


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

    puts 'db settings:'
    pp config

    ### for dbbrowser and other tools add to ActiveRecord

    if ActiveRecord::Base.configurations.nil?   # todo/check: can this ever happen? remove?
       puts "ActiveRecord configurations nil - set to empty hash"
       ActiveRecord::Base.configurations = {}  # make it an empty hash
    end

    if debug?
      puts 'ar configurations (before):'
      pp ActiveRecord::Base.configurations
    end

    # note: for now always use pluto key for config storage
    ActiveRecord::Base.configurations['pluto'] = config

    if debug?
      puts 'ar configurations (after):'
      pp ActiveRecord::Base.configurations
    end


    # for debugging - disable for production use
    if debug?
      ActiveRecord::Base.logger = Logger.new( STDOUT )
    end

    ActiveRecord::Base.establish_connection( config )
  end # method connect


end # class Connecter

end # module Pluto
