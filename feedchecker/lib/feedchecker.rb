require 'pp'

# our own code
require 'feedchecker/version'   # note: let version always go first



# say hello
puts FeedChecker.banner   if $DEBUG || (defined?($RUBYLIBS_DEBUG) && $RUBYLIBS_DEBUG)
