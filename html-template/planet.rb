
require_relative './tmpl.rb'


## check templates from original planet.py distribution
##  see https://people.gnome.org/~jdub/bzr/planet/devel/trunk/examples/


tmpl = File.open( 'planet_examples_basic_index.html.tmpl', 'r:utf-8') {|f| f.read }

t = HtmlTemplate.new( tmpl )
puts "---"
## puts t.text

File.open( 'planet_examples_basic_index.html.erb', 'w:utf-8') {|f| f.write(t.text) }
