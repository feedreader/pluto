# encoding: utf-8


module Pluto

class Formatter

  include LogUtils::Logging

  include Models
  include ManifestHelper
  
  include TextUtils::DateHelper  # e.g. lets us use time_ago_in_words
  include TextUtils::HypertextHelper # e.g. lets us use link_to, strip_tags, sanitize, textify, etc.

  def initialize( opts, config )
    @opts    = opts
    @config  = config
  end

  attr_reader :opts, :config, :site


  def run( arg )
    ### remove - always use make( site_key )
    ## fix: change arg to planet_key or just key or similar
    #  todo: rename run to some less generic  - merge/build/etc. ??
    
    site_key = arg
    site_key = site_key.downcase.gsub('.ini','').gsub('.yml','')  # remove .ini|.yml extension if present

    manifest_name = opts.manifest
    output_path   = opts.output_path

    make_for(site_key, manifest_name, output_path )
  end


  def make_for( site_key, manifest_name, output_path )

    ## fix: remove reference to opts
    ##  - e.g. now still used for auto-installer

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
    pakpath     = output_path

    @site = Site.find_by_key( site_key )
    if @site.nil?
      puts "*** warn: no site with key '#{site_key}' found; using untitled site record"
      @site = Site.new
      @site.title = 'Planet Untitled'
    end

    Pakman::Templater.new.merge_pak( manifestsrc, pakpath, binding, site_key )
  end

end # class Formatter

end # module Pluto
