# encoding: utf-8

require 'gli'


include GLI::App

program_desc 'another planet generator (lets you build web pages from published web feeds)'
version PlutoCli::VERSION


## some setup code

LogUtils::Logger.root.level = :info   # set logging level to info

logger = LogUtils::Logger.root


opts    = Pluto::Opts.new



######
# begin
#  move to pluto for reuse (e.g. in rakefile)

def load_config( name )
  config = INI.load_file( name )
  config
end

# end
#  move to pluto for reuse (e.g. in rakefile)
###########################


def expand_config_args( args )
  ## todo/check:  rename method?? e.g. check_config_args
  ##              or  auto_complete_config_ars similar? why? why not??

  if args.empty?      ## no args? args.length == 0
    ['planet.ini']    #    add default planet.ini for convenience
  else
    args   # pass through as-is
  end
end



## "global" options (switches/flags)


##  todo/check:
## use quiet (warn) and quieter (error) - why? why not?
##  use quiet for warn level (not error) as default - why? why not?

desc 'Only show warnings, errors and fatal messages'
switch [:q, :quiet, :w, :warn], negatable: false

desc 'Only show errors and fatal messages'
switch [:quieter, :err, :error], negatable: false

desc '(Debug) Show debug messages'
switch [:verbose, :debug], negatable: false



desc 'Configuration Path'
arg_name 'PATH'
default_value opts.config_path
flag [:c, :config]


### note: mostly for debugging lets you fetch individual feeds
desc 'Fetch feeds'
arg_name 'FEED', multiple: true   ## todo/fix: check multiple will not print typeo???
command [:fetch, :f] do |c|

  c.desc 'Database path'
  c.arg_name 'PATH'
  c.default_value opts.db_path
  c.flag [:d, :dbpath]

  c.desc 'Database name'
  c.arg_name 'NAME'
  c.default_value opts.db_name
  c.flag [:n, :dbname]

  c.action do |g,o,args|
    logger.debug 'hello from fetch command'

    ##  turn on debug flag by default; no need to passing --verbose
    Pluto.config.debug        = true
    Pluto.config.logger.level = :debug
    opts.verbose = true

    # add dbname as opts property

    #####
    # todo: add into method for reuse for build/merge/fetch
    #   all use the same code

    db_config = {
      adapter:  'sqlite3',
      database: "#{opts.db_path}/#{opts.db_name}"
    }

    Pluto.connect( db_config )

    args.each do |arg|
      feed_rec = Pluto::Model::Feed.find_by_key!( arg )

      puts "feed_rec:"
      pp feed_rec

      fetcher = Pluto::FeedFetcherBasic.new

      feed = fetcher.fetch( feed_rec )
      ## pp feed
    end

    puts 'Done.'
  end
end # command fetch



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

  c.desc 'Database path'
  c.arg_name 'PATH'
  c.default_value opts.db_path
  c.flag [:d, :dbpath]

  c.desc 'Database name'
  c.arg_name 'NAME'
  c.flag [:n, :dbname]


  c.action do |g,o,args|
    logger.debug 'hello from merge command'

    args = expand_config_args( args )   # if missing add default config (e.g. planet.ini)

    args.each do |arg|
      name    = File.basename( arg, '.*' )

      #####
      # todo: add into method for reuse for build/merge/fetch
      #   all use the same code

      db_name = opts.db_name? ? opts.db_name : "#{name}.db"

      db_config = {
        adapter:  'sqlite3',
        database: "#{opts.db_path}/#{db_name}"
      }

      Pluto.connect( db_config )

      config = load_config( arg )
      if opts.verbose?
        puts "dump >#{name}<:"
        pp config
      end

      Pluto::Formatter.new( opts, config ).run( name )
    end

    puts 'Done.'
  end
end # command merge


## note: same as build (but without step 2) merge)
desc 'Update planet feeds'
arg_name 'FILE', multiple: true   ## todo/fix: check multiple will not print typeo???
command [:update, :up, :u] do |c|

  c.desc 'Database path'
  c.arg_name 'PATH'
  c.default_value opts.db_path
  c.flag [:d, :dbpath]

  c.desc 'Database name'
  c.arg_name 'NAME'
  c.flag [:n, :dbname]


  c.action do |g,o,args|
    logger.debug 'hello from update command'

    args = expand_config_args( args )   # if missing add default config (e.g. planet.ini)

    args.each do |arg|
      name    = File.basename( arg, '.*' )

      #####
      # todo: add into method for reuse for build/merge/fetch
      #   all use the same code

      db_name = opts.db_name? ? opts.db_name : "#{name}.db"

      db_config = {
        adapter:  'sqlite3',
        database: "#{opts.db_path}/#{db_name}"
      }

      # Note: use ! version w/ auto-migrate!  - why? why not??
      ## just use regular connect??
      Pluto.connect!( db_config )

      config = load_config( arg )
      if opts.verbose?
        puts "dump >#{name}<:"
        pp config
      end

      Pluto::Updater.new( opts, config ).run( name )
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

  c.desc 'Database path'
  c.arg_name 'PATH'
  c.default_value opts.db_path
  c.flag [:d, :dbpath]

  c.desc 'Database name'
  c.arg_name 'NAME'
  c.flag [:n, :dbname]


  c.action do |g,o,args|
    logger.debug 'hello from build command'

    args = expand_config_args( args )   # if missing add default config (e.g. planet.ini)

    args.each do |arg|
      name    = File.basename( arg, '.*' )

      db_name = opts.db_name? ? opts.db_name : "#{name}.db"

      db_config = {
        adapter:  'sqlite3',
        database: "#{opts.db_path}/#{db_name}"
      }

      # Note: use ! version w/ auto-migrate!
      Pluto.connect!( db_config )

      config = load_config( arg )
      if opts.verbose?
        puts "dump >#{name}<:"
        pp config
      end

      Pluto::Updater.new( opts, config ).run( name )
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

    Pluto::SysInfo.new( opts ).dump
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

  puts PlutoCli.banner

  if opts.verbose?
    Pluto.config.debug        = true
    Pluto.config.logger.level = :debug
  elsif opts.warn?
    Pluto.config.logger.level = :warn
  elsif opts.error?
    Pluto.config.logger.level = :error
  else
    ## do nothing; keep :info level (default)
  end

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
