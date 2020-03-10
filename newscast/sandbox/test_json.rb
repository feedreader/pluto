require 'json'
require 'pp'


def subscribe( *feeds )
  puts "feeds:"
  pp feeds
  puts "feeds.size: #{feeds.size}"
  puts "feeds[0].class.name: #{feeds[0].class.name}"
  pp feeds[0]
end


data = JSON.parse( <<TXT )
["http://feeds.feedburner.com/nymag/intel",
 "http://radio3.io/users/davewiner/rss.xml",
 "http://www.schockwellenreiter.de/feed/",
 "http://feed.dilbert.com/dilbert/blog"]
TXT

pp data
subscribe( data )
subscribe( "http://feed.dilbert.com/dilbert/blog" )

