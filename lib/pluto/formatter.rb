module Pluto

class Formatter

  include LogUtils::Logging

  include Models
  include ManifestHelper

  def initialize( opts, config )
    @opts    = opts
    @config  = config
  end

  attr_reader :opts

  def site
    @config
  end

  def run( arg )
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
    Pakman::Templater.new.merge_pak( manifestsrc, pakpath, binding, name )
  end

end # class Formatter

end # module Pluto
