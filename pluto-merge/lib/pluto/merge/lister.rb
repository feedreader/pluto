# encoding: utf-8


module Pluto

class Lister

  include LogUtils::Logging

  include ManifestHelper

  def initialize( opts )
    @opts    = opts
  end

  attr_reader :opts

  def list
    home = Env.home
    ## replace home w/ ~ (to make out more readable (shorter))
    ## e.g. use gsub( home, '~' )

    logger.info 'Installed template packs in search path'

    installed_template_manifest_patterns.each_with_index do |pattern,i|
      logger.info "    [#{i+1}] #{pattern.gsub(home,'~')}"
    end
    logger.info '  include:'

    manifests = installed_template_manifests
    if manifests.empty?
      logger.info "    -- none --"
    else
      manifests.each do |manifest|
        pakname      = manifest[0].gsub('.txt','')
        manifestpath = manifest[1].gsub(home,'~')
        logger.info "%16s (%s)" % [pakname,manifestpath]
      end
    end
  end # method list

end # class Lister

end # module Pluto
