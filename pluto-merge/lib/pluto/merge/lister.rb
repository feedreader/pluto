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

    puts ''
    puts 'Installed template packs in search path'
    
    installed_template_manifest_patterns.each_with_index do |pattern,i|
      puts "    [#{i+1}] #{pattern.gsub(home,'~')}"
    end
    puts '  include:'
    
    manifests = installed_template_manifests
    if manifests.empty?
      puts "    -- none --"
    else
      manifests.each do |manifest|
        pakname      = manifest[0].gsub('.txt','')
        manifestpath = manifest[1].gsub(home,'~')
        puts "%16s (%s)" % [pakname,manifestpath]
      end
    end
  end # method list

end # class Lister

end # module Pluto
