###
#  to run use
#     ruby -I ./lib script/test.rb


require 'pluto/news'


# News.configure do |config|
#   config.database = ':memory:'
# end


News.subscribe(
  'http://www.ruby-lang.org/en/feeds/news.rss',     # Ruby Lang News
  'http://www.jruby.org/atom.xml',                  # JRuby Lang News
  'http://blog.rubygems.org/atom.xml',              # RubyGems News
  'http://bundler.io/blog/feed.xml',                # Bundler News
  'http://weblog.rubyonrails.org/feed/atom.xml',    # Ruby on Rails News
  'http://sinatrarb.com/feed.xml',                  # Sinatra News
  'https://hanamirb.org/atom.xml',                  # Hanami News
  'http://jekyllrb.com/feed.xml',                   # Jekyll News
  'http://feeds.feedburner.com/jetbrains_rubymine?format=xml',  # RubyMine IDE News
  'https://blog.phusion.nl/rss/',                   # Phusion News
  'https://rubyinstaller.org/feed.xml',             # Ruby Installer for Windows News
  'http://planetruby.github.io/calendar/feed.xml',  # Ruby Conferences & Camps News
  'https://rubytogether.org/news.xml',              # Ruby Together News
  'https://foundation.travis-ci.org/feed.xml',      # Travis Foundation News
  'https://railsgirlssummerofcode.org/blog.xml',    # Rails Girls Summer of Code News

  'http://blog.zenspider.com/atom.xml',          # Ryan Davis @ Seattle › Washington › United States
  'http://tenderlovemaking.com/atom.xml',        # Aaron Patterson @ Seattle › Washington › United States
  'http://blog.headius.com/feed.xml',            # Charles Nutter @ Richfield › Minnesota › United States
  'http://www.schneems.com/feed.xml',            # Richard Schneeman @ Austin › Texas › United States
  'https://eregon.me/blog/feed.xml',             # Benoit Daloze @ Zurich › Switzerland
  'http://samsaffron.com/posts.rss',             # Sam Saffron @ Sydney › Australia 
  )


News.update

puts ":::::::::::::::::::::::::::::::::::::::::::::::::::"
puts ":: #{News.items.count} news items from #{News.channels.count} channels:"
puts

puts "By Year:"
(2010..Date.today.year).each do |year|
  puts "  year #{year}: #{News.year(year).count}"
end
puts

puts "By Month in #{Date.today.year}:"
(1..Date.today.month).each do |month|
  puts "  month #{month}: #{News.month(month).count}"
end
puts

year = Date.today.year
puts "By Week in #{year}:"
(1..Date.today.cweek).each do |week|
  print "  week %2d: %4d" % [week, News.week(week).count]
  print "   - #{Date.commercial(year,week,1).strftime('%a %b %d, %Y')} to #{Date.commercial(year,week,7).strftime('%a %b %d, %Y')}"
  print "\n"
end
puts

year = Date.today.year-1
puts "By Week in #{year}:"
(1..52).each do |week|    ## (always) assume 52 weeks for now
  print "  week %2d: %4d" % [week, News.week(week, year).count]
  print "   - #{Date.commercial(year,week,1).strftime('%a %b %d, %Y')} to #{Date.commercial(year,week,7).strftime('%a %b %d, %Y')}"
  print "\n"
end
puts


puts "This Year:    #{News.this_year.count}"
puts "This Month:   #{News.this_month.count}"
puts "This Week:    #{News.this_week.count}"
puts "Today:        #{News.today.count}"
puts

puts "100 Latest News Items"
News.latest.limit( 100 ).each do |item|
  print "%4dd " % (Date.today.jd-item.updated.to_date.jd)
  print "  #{item.updated}"
  print " - #{item.title}"
  print " - #{item.feed.feed_url}"   ## fix: use title or something
  print "\n"
end
puts

puts "Channels"
News.channels.each do |channel|
  if channel.updated?
    print "%4dd " % (Date.today.jd-channel.updated.to_date.jd)
  else
    print "   ?  "
  end
  print "  #{channel.updated}"
  print " - %4d" % channel.items.count
  print " - #{channel.feed_url}"   ## fix: use title or something
  print "\n"
end


