require 'newscast'


path = "./rubyland.opml.xml"

h = OPML.load_file( path )
pp h


feeds = []

h['outline'].each do |item|
  text    = item['text']
  xml_url = item['xmlUrl']
  url     = item['url']

  puts text.empty?    ? '?' : text
  puts xml_url.empty? ? '?' : xml_url
  puts url.empty?     ? '?' : url
  puts

  feeds << xml_url
end

puts "#{feeds.size} feeds:"
pp feeds



News.config.database = './rubyland.db'


News.subscribe( *feeds )
News.update
