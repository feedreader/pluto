module Pluto

class Formatter

  def initialize( logger, opts, config )
    @logger  = logger
    @opts    = opts
    @config  = config
  end

  attr_reader :logger, :opts

  def run( arg )
    manifest_name = opts.manifest
    manifest_name = manifest_name.downcase.gsub('.txt', '' )  # remove .txt if present
    
    logger.debug "manifest=#{manifest_name}"

    # check for matching manifests
    manifests = installed_template_manifests.select { |m| m[0] == manifest_name+'.txt' }
        
    if manifests.empty?
      puts "*** error: unknown template pack '#{manifest_name}'; use pluto -l to list installed template packs"
      exit 2
    end
        
    manifestsrc = manifests[0][1]
    pakpath     = opts.output_path
    
        
    name = arg
    Pakman::Templater.new( logger ).merge_pak( manifestsrc, pakpath, binding, name )
  end

private

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
    patterns += builtin_patterns
  end

  def installed_template_manifests
    excludes = [
      "Manifest.txt",
      "*/Manifest.txt"
    ]    
    
    Pakman::Finder.new( logger ).find_manifests( installed_template_manifest_patterns, excludes )
  end

end # class Formatter

end # module Pluto
