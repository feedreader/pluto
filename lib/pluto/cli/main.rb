# encoding: utf-8

require 'gli'


include GLI::App

program_desc 'another planet generator (lets you build web pages from published web feeds)'
version Pluto::VERSION


## some setup code 

LogUtils::Logger.root.level = :info   # set logging level to info 

logger = LogUtils::Logger.root


opts    = Pluto::Opts.new



class SysInfo
  
  ## todo/fix:
  ##   pass in/use config (props)
  
  def initialize( opts )
    @opts = opts
  end
  
  attr_reader :opts


  def dump
  puts <<EOS

#{Pluto.banner}

Gems versions:
  - pakman #{Pakman::VERSION}
  - fetcher #{Fetcher::VERSION}
  - feedutils #{FeedUtils::VERSION}
  - textutils #{TextUtils::VERSION}
  - props #{Props::VERSION}

    Env home: #{Env.home}
Pluto config: #{opts.config_path}
  Pluto root: #{Pluto.root}

EOS

  # dump Pluto settings
  # config.dump
  # puts
      

  ## todo: add more gem version info
  # todo: add  logutils version
  #       add  gli2     version
  end

end # class SysInfo




## "global" options (switches/flags)

desc '(Debug) Show debug messages'
switch [:verbose], negatable: false    ## todo: use -w for short form? check ruby interpreter if in use too?

desc 'Only show warnings, errors and fatal messages'
switch [:q, :quiet], negatable: false


desc 'Configuration Path'
arg_name 'PATH'
default_value opts.config_path
flag [:c, :config] 


## note: same as build (but without step 1) fetch)
desc 'Merge planet template pack'
arg_name 'FILE', multiple: true   ## todo/fix: check multiple will not print typeo???
command [:merge, :m] do |c|

  c.desc 'Output Path'
  c.arg_name 'PATH'
  c.default_value opts.output_path
  c.flag [:o,:output]

  c.desc 'Template Manifest'
  c.arg_name 'MANIFEST'
  c.default_value opts.manifest
  c.flag [:t, :template]


  c.action do |g,o,args|
    logger.debug 'hello from merge command'

    if args.length == 0
      if File.exists?( 'pluto.yml' ) # check if pluto.yml exists, if yes add/use it
        args = ['pluto.yml']  # create a new args w/ one item
      elsif File.exists?( 'planet.yml' ) # check if planet.yml exists, if yes add/use it
        args = ['planet.yml'] # create a new args w/ one item
      else
        puts '*** note: no arg passed in; no pluto.yml or planet.yml found in working folder'
      end
    end

    args.each do |arg|
      name = File.basename( arg, '.*' )

      #####
      # todo: add into method for reuse for build/merge/fetch
      #   all use the same code
 
      db_config = {
        adapter:  'sqlite3',
        database: "#{opts.output_path}/#{name}.db"
      }
 
      Pluto::Connecter.new.connect!( db_config )

      config_path = arg.dup   # add .yml file extension if missing (for convenience)
      config_path << '.yml'  unless config_path.ends_with?( '.yml' )

      config = YAML.load_file( config_path )
      
      puts "dump >#{config_path}<:"
      pp config
    
      Pluto::Formatter.new( opts, config ).run( name )
    end
    
    puts 'Done.'
  end
end # command merge


## note: same as build (but without step 2) merge)
desc 'Fetch planet feeds'
arg_name 'FILE', multiple: true   ## todo/fix: check multiple will not print typeo???
command [:fetch, :f] do |c|

  c.action do |g,o,args|
    logger.debug 'hello from fetch command'

    if args.length == 0
      if File.exists?( 'pluto.yml' ) # check if pluto.yml exists, if yes add/use it
        args = ['pluto.yml']  # create a new args w/ one item
      elsif File.exists?( 'planet.yml' ) # check if planet.yml exists, if yes add/use it
        args = ['planet.yml'] # create a new args w/ one item
      else
        puts '*** note: no arg passed in; no pluto.yml or planet.yml found in working folder'
      end
    end

    args.each do |arg|
      name = File.basename( arg, '.*' )

      #####
      # todo: add into method for reuse for build/merge/fetch
      #   all use the same code
 
      db_config = {
        adapter:  'sqlite3',
        database: "#{opts.output_path}/#{name}.db"
      }
 
      Pluto::Connecter.new.connect!( db_config )

      config_path = arg.dup   # add .yml file extension if missing (for convenience)
      config_path << '.yml'  unless config_path.ends_with?( '.yml' )

      config = YAML.load_file( config_path )
      
      puts "dump >#{config_path}<:"
      pp config
    
      Pluto::Fetcher.new( opts, config ).run
    end
    
    puts 'Done.'
  end
end # command fetch



desc 'Build planet'
arg_name 'FILE', multiple: true   ## todo/fix: check multiple will not print typeo???
command [:build, :b] do |c|

  c.desc 'Output Path'
  c.arg_name 'PATH'
  c.default_value opts.output_path
  c.flag [:o,:output]

  c.desc 'Template Manifest'
  c.arg_name 'MANIFEST'
  c.default_value opts.manifest
  c.flag [:t, :template]


  c.action do |g,o,args|
    logger.debug 'hello from build command'

    if args.length == 0
      if File.exists?( 'pluto.yml' ) # check if pluto.yml exists, if yes add/use it
        args = ['pluto.yml']  # create a new args w/ one item
      elsif File.exists?( 'planet.yml' ) # check if planet.yml exists, if yes add/use it
        args = ['planet.yml'] # create a new args w/ one item
      else
        puts '*** note: no arg passed in; no pluto.yml or planet.yml found in working folder'
      end
    end

    args.each do |arg|

      name = File.basename( arg, '.*' )
 
      db_config = {
        adapter:  'sqlite3',
        database: "#{opts.output_path}/#{name}.db"
      }
 
      Pluto::Connecter.new.connect!( db_config )

      config_path = arg.dup   # add .yml file extension if missing (for convenience)
      config_path << '.yml'  unless config_path.ends_with?( '.yml' )

      config = YAML.load_file( config_path )
      
      puts "dump >#{config_path}<:"
      pp config
    
      Pluto::Fetcher.new( opts, config ).run
      Pluto::Formatter.new( opts, config ).run( name )
      
    end
    
    puts 'Done.'
  end
end # command build


desc 'List installed template packs'
command [:list,:ls,:l] do |c|

  c.action do |g,o,args|
    logger.debug 'hello from list command'

    Pluto::Lister.new( opts ).list
  end
end


desc 'Install template pack'
arg_name 'MANIFEST', multiple: true
command [:install,:i] do |c|

  c.action do |g,o,args|
    logger.debug 'hello from install command'
        
    args.each do |arg|
      Pluto::Installer.new( opts ).install( arg )  ## todo: remove opts merge into config
    end
  end
end


desc '(Debug) Show more version info'
skips_pre
command [:about,:a] do |c|
  c.action do
    logger.debug 'hello from about command'

    SysInfo.new( opts ).dump
  end
end


desc '(Debug) Show global options, options, arguments for test command'
command :test do |c|
  c.action do |g,o,args|
    puts 'hello from test command'
    puts 'g/global_options:'
    pp g
    puts 'o/options:'
    pp o
    puts 'args:'
    pp args
  end
end



pre do |g,c,o,args|
  opts.merge_gli_options!( g )
  opts.merge_gli_options!( o )

  puts Pluto.banner
  
  LogUtils::Logger.root.level = :debug    if opts.verbose?

  logger.debug "   executing command #{c.name}"
  true
end


post do |global,c,o,args|
  logger.debug "   executed command #{c.name}"
  true
end


on_error do |e|
  puts
  puts "*** error: #{e.message}"
  puts

  ## todo/fix: find a better way to print; just raise exception e.g. raise e  - why? why not??
  ## puts e.backtrace.inspect  if opts.verbose?
  raise e   if opts.verbose?

  false # skip default error handling
end


exit run(ARGV)