# encoding: utf-8


module Pluto

class Installer

### fix: remove opts, use config (wrapped!!)
  
  include LogUtils::Logging
  
  def initialize( opts )
    @opts    = opts
  end

  attr_reader :opts


  def install( shortcut_or_source )

    logger.debug "fetch >#{shortcut_or_source}<"
    
    ## check for builtin shortcut (assume no / or \) 
    if shortcut_or_source.index( '/' ).nil? && shortcut_or_source.index( '\\' ).nil?
      shortcut = shortcut_or_source
      sources = opts.map_fetch_shortcut( shortcut )

      if sources.empty?
        puts "** Error: No mapping found for shortcut '#{shortcut}'."
        return
      end
      puts "  Mapping fetch shortcut '#{shortcut}' to: #{sources.join(',')}"
    else
      sources = [shortcut_or_source]  # pass arg through unmapped
    end

    sources.each do |source|
      install_template( source )
    end

  end # method run


  def install_template( src )
    # src = 'http://github.com/geraldb/slideshow/raw/d98e5b02b87ee66485431b1bee8fb6378297bfe4/code/templates/fullerscreen.txt'
    # src = 'http://github.com/geraldb/sandbox/raw/13d4fec0908fbfcc456b74dfe2f88621614b5244/s5blank/s5blank.txt'
    uri = URI.parse( src )
    logger.debug "scheme: #{uri.scheme}, host: #{uri.host}, port: #{uri.port}, path: #{uri.path}"

    pakname = File.basename( uri.path ).downcase.gsub('.txt','')
    pakpath = File.expand_path( "#{opts.config_path}/#{pakname}" )
    
    logger.debug "packname >#{pakname}<"
    logger.debug "pakpath >#{pakpath}<"
  
    Pakman::Fetcher.new.fetch_pak( src, pakpath )
  end

end # class Installer

end # module Pluto
