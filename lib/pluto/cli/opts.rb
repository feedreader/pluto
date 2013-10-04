module Pluto

class Opts

  def initialize
    load_shortcuts
  end


  def merge_gli_options!( options={} )
    @verbose = true     if options[:verbose] == true

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

  def verbose=(value)
    @verbose = true  # note: always assumes true for now; default is false
  end

  def verbose?
    @verbose || false
  end

  def config_path=(value)
    @config_path = value
  end
  
  def config_path
    ## @config_path || '~/.pluto'   --- old code
    @config_path || File.join( Env.home, '.pluto' )
  end


  def output_path=(value)
    @output_path = value
  end
  
  def output_path
    @output_path || '.'
  end

  def load_shortcuts
    @shortcuts = YAML.load_file( "#{Pluto.root}/config/pluto.index.yml" )
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
