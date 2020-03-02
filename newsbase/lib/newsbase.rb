require 'pp'

# our own code
require 'newsbase/version'   # note: let version always go first



# say hello
puts Newsbase.banner   if $DEBUG || (defined?($RUBYLIBS_DEBUG) && $RUBYLIBS_DEBUG)
