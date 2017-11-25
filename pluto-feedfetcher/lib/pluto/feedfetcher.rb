# encoding: utf-8


require 'pluto/models'


# more 3rd party gems
require 'fetcher'    # fetch (text) documents


# our own code
require 'pluto/feedfetcher/version'   # Note: let version always go first
require 'pluto/feedfetcher/basic'
require 'pluto/feedfetcher/cond_get_with_cache'



# say hello
puts PlutoFeedFetcher.banner   if $DEBUG || (defined?($RUBYLIBS_DEBUG) && $RUBYLIBS_DEBUG)
