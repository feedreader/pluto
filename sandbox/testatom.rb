
# stdlibs
require 'rss'
require 'pp'

# 3rd party libs/gems
require 'fetcher'

feed_url = 'http://weblog.rubyonrails.org/feed/atom.xml'   # atom 

xml = Fetcher.read( feed_url )

feed = RSS::Parser.parse( xml, true )  # true => ignore unknown elements

############
#    format version mappings:
#  RSS::Atom::Feed   => atom


###########
# Note: RSS::Atom::Feed
#   - has no feed_version  => assumes always 1.0 for now (no other atom format exists)



##################
# RSS::Rss
# - see http://www.ruby-doc.org/stdlib-2.0.0/libdoc/rss/rdoc/RSS/Rss.html

puts "feed.class: #{feed.class.name}"


# puts "dump feed.channel:"
# puts feed.channel.inspect

puts "dump feed.title (#{feed.title.class.name}):"
pp feed.title

puts "dump feed.id (#{feed.id.class.name}):"
pp feed.id

puts "dump feed.updated (#{feed.updated.class.name}):"
pp feed.updated

puts "dump feed.published (#{feed.published.class.name}):"
pp feed.published

# puts "dump feed:"
# pp feed





