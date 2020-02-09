###
#  to run use
#     ruby -I ./lib script/test_convert.rb


require 'html/template'


files = [
  'opml.xml.tmpl',
  'planet/basic/index.html.tmpl'
].each do |name|
   text = File.open( "./test/templates/#{name}", "r:utf-8" ).read
   t = HtmlTemplate.new( text )
 
   puts "--- #{name}:"
   puts t.text
   puts 
   puts
end