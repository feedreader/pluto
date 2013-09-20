module Pluto

class Opts

  def merge_gli_options!( options={} )
    @verbose = true     if options[:verbose] == true
    
    @config_path = options[:config]    if options[:config].present?
    @output_path = options[:output]    if options[:output].present?
    
    @manifest       =   options[:template]  if options[:template].present?
  end


  def manifest=(value)
    @manifest = value
  end
  
  def manifest
    @manifest || 'blank'
  end

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


end # class Opts

end # module Pluto
