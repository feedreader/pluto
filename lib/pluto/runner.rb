
module Pluto

class Runner

  def initialize
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::INFO

    @opts    = Opts.new
  end

  attr_reader :logger, :opts

  def run( args )
    opt=OptionParser.new do |cmd|
    
      cmd.banner = "Usage: pluto [options]"

      cmd.on( '-t', '--template MANIFEST',  'Generate Templates' ) do |manifest|
        opts.manifest = manifest
      end
    
      cmd.on( '-c', '--config PATH', "Configuration Path (default is #{opts.config_path})" ) do |path|
        opts.config_path = path
      end
    
      cmd.on( '-o', '--output PATH', "Output Path (default is #{opts.output_path})" ) { |path| opts.output_path = path }

      cmd.on( '-v', '--version', "Show version" ) do
        puts Pluto.banner
        exit
      end

      cmd.on( "--verbose", "Show debug trace" )  do
        logger.datetime_format = "%H:%H:%S"
        logger.level = Logger::DEBUG
      end

      cmd.on_tail( "-h", "--help", "Show this message" ) do
        puts <<EOS

pluto - Lets you build web pages from published web feeds.

#{cmd.help}

Examples:
    pluto ruby                          # to be done

Further information:
  http://geraldb.github.com/pluto
  
EOS
        exit
      end
    end

    opt.parse!( args )
  
    puts Pluto.banner

    args.each do |arg|

      name = File.basename( arg, '.*' )
 
      db_config = {
        :adapter  => 'sqlite3',
        :database => "#{opts.output_path}/#{name}.sqlite"
      }
 
      setup_db( db_config )

      config_path = arg.dup   # add .yml file extension if missing (for convenience)
      config_path << '.yml'  unless config_path.ends_with?( '.yml' )

      config = YAML.load_file( config_path )
      
      puts "dump >#{config_path}<:"
      pp config
    
      Fetcher.new( logger, opts, config ).run
      Formatter.new( logger, opts, config ).run( name )
      
    end
    
    puts 'Done.'
    
  end   # method run


private

  def setup_db( db_config )
        
    ActiveRecord::Base.establish_connection( db_config )
    
    unless Feed.table_exists?
      ActiveRecord::Schema.define do
        create_table :feeds do |t|
          t.string  :title,    :null => false
          t.string  :url,      :null => false
          t.string  :feed_url, :null => false
          t.string  :key,      :null => false
          t.timestamps
        end

        create_table :items do |t|
          t.string   :title   # todo: add some :null => false ??
          t.string   :url
          t.string   :guid
          t.text     :content
          t.datetime :published_at
          t.references :feed, :null => false
          t.timestamps
        end
      end
    end
  end # method setup_db

end # class Runner
end # module Pakman