# frozen_string_literal: true

module Pluto
  MAJOR = 1
  MINOR = 6
  PATCH = 2
  VERSION = [MAJOR, MINOR, PATCH].join('.')

  def self.version
    VERSION
  end

  def self.banner
    ### todo: add RUBY_PATCHLEVEL or RUBY_PATCH_LEVEL  e.g. -p124
    "pluto-models/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  ## Note: moved from pluto-merge (add here because pluto-merge gem is optional)
  ##  fix: remove generator in pluto-merge!!! (duplicate)
  # convenience alias for banner (matches HTML generator meta tag)
  def self.generator
    "Pluto #{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    File.expand_path(File.dirname(File.dirname(File.dirname(__FILE__)))).to_s
  end
end
