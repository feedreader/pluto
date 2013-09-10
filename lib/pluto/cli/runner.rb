
module Pluto

class Runner

  include LogUtils::Logging
  
  include Models  # e.g. Feed,Item,Site,etc.

  def initialize
   @opts = Opts.new
  end

  attr_reader :opts

  def run( args )
    opt=OptionParser.new do |cmd|
    
      cmd.banner = "Usage: pluto [options] FILE"

      ## fix/todo: remove .txt from default manifest 

      cmd.on( '-t', '--template MANIFEST',  "Template Manifest (default is #{opts.manifest})" ) do |manifest|
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
        LogUtils::Logger.root.level = :debug
        opts.verbose = true
      end

      ## todo: add/allow -?  too
      cmd.on_tail( "-h", "--help", "Show this message" ) do
        puts <<EOS

pluto - Lets you build web pages from published web feeds.

#{cmd.help}

Examples:
    pluto ruby

Further information:
  https://github.com/geraldb/pluto
  
EOS
        exit
      end
    end

    opt.parse!( args )
  
    puts Pluto.banner

    args.each do |arg|

      name = File.basename( arg, '.*' )
 
      db_config = {
        adapter:  'sqlite3',
        database: "#{opts.output_path}/#{name}.db"
      }
 
      Connecter.new.connect!( db_config )

      config_path = arg.dup   # add .yml file extension if missing (for convenience)
      config_path << '.yml'  unless config_path.ends_with?( '.yml' )

      config = YAML.load_file( config_path )
      
      puts "dump >#{config_path}<:"
      pp config
    
      Fetcher.new( opts, config ).run
      Formatter.new( opts, config ).run( name )
      
    end
    
    puts 'Done.'
    
  end   # method run


end # class Runner
end # module Pakman