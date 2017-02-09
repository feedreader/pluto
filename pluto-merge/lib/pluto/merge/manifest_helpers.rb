# encoding: utf-8

module Pluto

###
# Note: requires/needs
#   opts.config_path   reference


module ManifestHelper

  ## shared methods for handling manifest lookups
  ##
  #  note: required attribs (in host class) include:
  #     - opts.config_path
  
  def installed_template_manifest_patterns

    # 1) search .    # that is, working/current dir
    # 2) search <config_dir>
    # 3) search <gem>/templates

### 
# Note
# -- for now - no longer ship w/ builtin template packs
# - download on demand if needed

    builtin_patterns = [
##      "#{Pluto.root}/templates/*.txt"
    ]
    config_patterns  = [
##      "#{File.expand_path(opts.config_path)}/*.txt",
      "#{File.expand_path(opts.config_path)}/*/*.txt"
    ]
    current_patterns = [
##      "*.txt",
      "*/*.txt",
      "node_modules/*/*.txt", # note: add support for npm installs - use/make slideshow required in name? for namespace in the future???
    ]

    patterns = []
    patterns += current_patterns
    patterns += config_patterns
    patterns += builtin_patterns
  end

  def installed_template_manifests
    excludes = [
      "Manifest.txt",
      "*/Manifest.txt"
    ]    
    
    Pakman::Finder.new.find_manifests( installed_template_manifest_patterns, excludes )
  end


end # module Manifest
end # module Slideshow
