module Pluto

class Opts

  def manifest=(value)
    @manifest = value
  end
  
  def manifest
    @manifest || 'blank.txt'
  end


  def config_path=(value)
    @config_path = value
  end
  
  def config_path
    @config_path || '~/.pluto'
  end


  def output_path=(value)
    @output_path = value
  end
  
  def output_path
    @output_path || '.'
  end


end # class Opts

end # module Pluto
