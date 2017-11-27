# encoding: utf-8

module Pluto

class Opts

  def initialize
    load_shortcuts
  end


  def merge_gli_options!( options={} )
    ###
    #  todo/check: renamve verbose to debug and quiet to error - why? why not?
    #    use a single (internal) variable for log level - why? why not?

    if options[:verbose] == true   ## debug level
      @verbose = @warn = @error = true
    end

    if options[:warn]    == true   ## warn level -- alias for quiet
      @warn = @error = true
      @verbose = false
    end

    if options[:error]   == true   ## error level  -- alias for quieter
      @error = true
      @verbose = @warn = false
    end


    @db_path   = options[:dbpath]  if options[:dbpath].present?

    if options[:dbname].present?
      ##########
      # note: c.default_value '<PLANET>.db e.g. ruby.db'
      #  gli2 will set default if present - thus, do NOT set a default value
      #    otherwise it will get set

      @db_name   = options[:dbname]
      puts "setting opts.db_name to '#{options[:dbname]}'"
    end

    @config_path = options[:config]    if options[:config].present?
    @output_path = options[:output]    if options[:output].present?

    @manifest       =   options[:template]  if options[:template].present?
  end


  # lets us check if user passed in db settings
  def db_name?()   @db_name.present? ;  end

  def db_path()    @db_path || '.' ;         end
  def db_name()    @db_name || 'pluto.db' ;  end


  def manifest=(value)   @manifest = value;  end
  def manifest()         @manifest || 'blank' ;  end


  ##  # note: always assumes true for now for verbose/quiet/warn; default is false
  ##  todo: switch verbose to debug internally - why? why not?
  def verbose=(value)   @verbose = true;   end
  def verbose?()        @verbose || false; end
  def debug?()          @verbose || false; end   ## add debug? alias for verbose

  def warn=(value)      @warn = true;     end
  def warn?()           @warn || false;   end
  def quiet?()          @warn || false;  end   ## add quiet? alias for warn

  def error=(value)     @error = true;    end
  def error?()          @error || false;  end
  def quieter?()        @error || false;  end   ## add quieter? alias for error




  def config_path=(value)
    @config_path = value
  end

  def config_path
    ## note: defaults to  ~/.pluto
    @config_path || File.join( Env.home, '.pluto' )
  end


  def output_path=(value)
    @output_path = value
  end

  def output_path
    @output_path || '.'
  end

  def load_shortcuts
    ### Note: for now shortcuts packed w/ pluto-merge  - move to pluto (this gem??) why? why not?
    @shortcuts = YAML.load_file( "#{PlutoMerge.root}/config/pluto.index.yml" )
  end

  def map_fetch_shortcut( key )
    # NB: always returns an array!!!  0,1 or more entries
    # - no value - return empty ary

    ## todo: normalize key???
    value = @shortcuts.fetch( key, nil )

    if value.nil?
      []
    elsif value.kind_of?( String )
      [value]
    else  # assume it's an array already;  ## todo: check if it's an array
      value
    end
  end


end # class Opts

end # module Pluto
