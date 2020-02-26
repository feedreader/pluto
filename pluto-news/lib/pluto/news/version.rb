
module PlutoNews

    MAJOR = 1
    MINOR = 1
    PATCH = 0
    VERSION = [MAJOR,MINOR,PATCH].join('.')
  
    def self.version
      VERSION
    end
  
    def self.banner
      ### todo: add RUBY_PATCHLEVEL or RUBY_PATCH_LEVEL  e.g. -p124
      "pluto-news/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
    end
  
    def self.root
      "#{File.expand_path( File.dirname(File.dirname(File.dirname(__FILE__))) )}"
    end
  
end # module PlutoNews
