# note: HtmlTemplate is a class (NOT a module) for now - change - why? why not?


class HtmlTemplate
    MAJOR = 0
    MINOR = 0
    PATCH = 1
    VERSION = [MAJOR,MINOR,PATCH].join('.')
  
    def self.version
      VERSION
    end
  
    def self.banner
      ### todo: add RUBY_PATCHLEVEL or RUBY_PATCH_LEVEL  e.g. -p124
      "html-template/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
    end
  
    def self.root
      File.expand_path( File.dirname(File.dirname(File.dirname(File.dirname(__FILE__)))) )
    end
  
  end # class HtmlTemplate
  