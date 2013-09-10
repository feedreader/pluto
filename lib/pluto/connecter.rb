module Pluto


# DB Connecter / Connection Manager
#   lets you establish connection 

class Connecter

  include LogUtils::Logging

  def initialize
    # do nothing for now
  end


  def connect!( config = nil )

    if config.nil?   # use DATABASE_URL

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
      else 
        config = {
          adapter:  db.scheme,       # sqlite3
          database: db.path[1..-1]   # pluto.db (NB: cut off leading /, thus 1..-1)
        }
      end
    end  # if config.nil?

    puts 'db settings:'
    pp config

    # for debugging - disable for production use
    ActiveRecord::Base.logger = Logger.new( STDOUT )

    ActiveRecord::Base.establish_connection( config )
    
    # first time? - auto-run db migratation, that is, create db tables
    unless Feed.table_exists?
       CreateDb.new.up  
    end
  end # method connect!


end # class Connecter

end # module Pluto
