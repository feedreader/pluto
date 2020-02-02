##
# to run / test use
#   ruby script/pluto.rb about
#   ruby script/pluto.rb help
# etc.

require 'pp'

## setup load path using local directories
$LOAD_PATH.unshift File.expand_path( '../pluto/lib' )
$LOAD_PATH.unshift File.expand_path( '../pluto-feedfetcher/lib' )
$LOAD_PATH.unshift File.expand_path( '../pluto-merge/lib' )
$LOAD_PATH.unshift File.expand_path( '../pluto-models/lib' )
$LOAD_PATH.unshift File.expand_path( '../pluto-update/lib' )

puts "$LOAD_PATH:"
pp $LOAD_PATH



require 'pluto'

Pluto.main
