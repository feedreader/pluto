

module Pluto
  class Configuration
  
    def debug=(value)  @debug = value;   end
    def debug?()       @debug || false;  end
  
    def logger   
       ## always return root for now; let's you globally configure e.g.
       ##     logger.level = :debug etc.    
       LogUtils::Logger.root
    end
  end # class Configuration
  

  
  ## lets you use
  ##   Pluto.configure do |config|
  ##      config.debug        = true
  ##      config.logger.level = :debug
  ##   end
  
  def self.configure
    yield( config )
  end
  
  def self.config
    @config ||= Configuration.new
  end
  
end   # module Pluto
