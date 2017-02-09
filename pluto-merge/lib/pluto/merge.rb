# encoding: utf-8

require 'pluto/models'

# 3rd party ruby gems/libs

require 'pakman'    # template pack manager
require 'fetcher'

# our own code

require 'pluto/merge/version'    # note: let version always get first
require 'pluto/merge/manifest_helpers'
require 'pluto/merge/installer'
require 'pluto/merge/lister'
require 'pluto/merge/formatter'


module Pluto

  def self.generator   # convenience alias for banner (matches HTML generator meta tag)
    "Pluto #{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

end  # module Pluto



# say hello
puts PlutoMerge.banner   if $DEBUG || (defined?($RUBYLIBS_DEBUG) && $RUBYLIBS_DEBUG) 
