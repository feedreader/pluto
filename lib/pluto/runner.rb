
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
    pluto                            # to be done

Further information:
  http://geraldb.github.com/pluto
  
EOS
        exit
      end
    end

    opt.parse!( args )
  
    puts Pluto.banner
    
    Fetcher.new( logger, opts ).run
    Formatter.new( logger, opts ).run
    
    puts 'Done.'
    
  end   # method run

end # class Runner
end # module Pakman