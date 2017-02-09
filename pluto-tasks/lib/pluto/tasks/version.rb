# encoding: utf-8

module PlutoTasks

  MAJOR = 1
  MINOR = 5
  PATCH = 3
  VERSION = [MAJOR,MINOR,PATCH].join('.')

  def self.version
    VERSION
  end

  def self.banner
    ### todo: add RUBY_PATCHLEVEL or RUBY_PATCH_LEVEL  e.g. -p124
    "pluto-tasks/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    "#{File.expand_path( File.dirname(File.dirname(File.dirname(File.dirname(__FILE__)))) )}"
  end

end # module PlutoTasks

