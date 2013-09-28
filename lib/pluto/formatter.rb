module Pluto

class Formatter

  include LogUtils::Logging

  include Models
  include ManifestHelper
  
  include TemplateHelper  # e.g. lets us use time_ago_in_words, strip_tags, etc.

  def initialize( opts, config )
    @opts    = opts
    @config  = config
  end

  attr_reader :opts, :config, :site

  def run( arg )
    ## fix: change arg to planet_key or just key or similar
    #  todo: rename run to some less generic  - merge/build/etc. ??
    
    manifest_name = opts.manifest
    manifest_name = manifest_name.downcase.gsub('.txt', '' )  # remove .txt if present
    
    logger.debug "manifest=#{manifest_name}"

    # check for matching manifests
    manifests = installed_template_manifests.select { |m| m[0] == manifest_name+'.txt' }
        
    if manifests.empty?
      
      ### try - autodownload
      puts "*** template pack '#{manifest_name}' not found; trying auto-install..."
      
      Installer.new( opts ).install( manifest_name )

      ### try again
      
      # check for matching manifests
      manifests = installed_template_manifests.select { |m| m[0] == manifest_name+'.txt' }
      
      if manifests.empty?
         puts "*** error: unknown template pack '#{manifest_name}'; use pluto ls to list installed template packs"
         exit 2
      end
    end

    manifestsrc = manifests[0][1]
    pakpath     = opts.output_path

    name = arg

    ## for now - use single site w/ key planet
    ##-- fix!! allow multiple sites (planets)

    site_key = 'planet'
    @site = Site.find_by_key( site_key )
    if @site.nil?
      puts "*** warn: no site with key '#{site_key}' found; using untitled site record"
      @site = Site.new
      @site.title = 'Planet Untitled'
    end

    Pakman::Templater.new.merge_pak( manifestsrc, pakpath, binding, name )
  end

end # class Formatter

end # module Pluto
