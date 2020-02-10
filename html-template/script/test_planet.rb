###
#  to run use
#     ruby -I ./lib script/test_planet.rb


require 'html/template'


## check templates from original planet.py distribution
##  see https://people.gnome.org/~jdub/bzr/planet/devel/trunk/examples/



files = [
  'basic/index.html.tmpl',
  'fancy/index.html.tmpl',
  'atom.xml.tmpl',
  'foafroll.xml.tmpl',
  'opml.xml.tmpl',
  'rss10.xml.tmpl',
  'rss20.xml.tmpl'
].each do |name|
   text = File.open( "./test/templates/planet/#{name}", "r:utf-8" ).read

   puts "--- #{name}:"
   puts text
   puts "---"

   t = HtmlTemplate.new( text )
   pp t.names

   puts "--- #{name} - erb:"
   puts t.text
   puts
   puts

   out_path = "tmp/#{File.dirname(name)}/#{File.basename(name,File.extname(name))}.erb"
   puts "out_path: #{out_path}"
   FileUtils.mkdir_p( File.dirname(out_path) )

   File.open( out_path, 'w:utf-8') {|f| f.write(t.text) }

=begin
   if t.errors.size > 0
    puts "!! ERROR - #{t.errors.size} conversion / syntax error(s):"
    pp t.errors
    raise   ## todo - find a good Error - StandardError - why? why not?
   end
=end

  end

