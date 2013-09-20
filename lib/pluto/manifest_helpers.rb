module Pluto

module ManifestHelper

  ## shared methods for handling manifest lookups
  ##
  #  note: required attribs (in host class) include:
  #     - opts.config_path
  
  def installed_template_manifest_patterns

    # 1) search .    # that is, working/current dir
    # 2) search <config_dir>
    # 3) search <gem>/templates

    builtin_patterns = [
      "#{Pluto.root}/templates/*.txt"
    ]
    config_patterns  = [
      "#{File.expand_path(opts.config_path)}/*.txt",
      "#{File.expand_path(opts.config_path)}/*/*.txt"
    ]
    current_patterns = [
      "*.txt",
      "*/*.txt"
    ]
    
    patterns = []
    patterns += current_patterns
    patterns += config_patterns
###    patterns += builtin_patterns    - for now - no longer ship w/ builtin template packs - download on demand if needed
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
