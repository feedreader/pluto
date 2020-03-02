###
#  to run use
#     ruby -I ./lib script/test_query.rb


require 'newscast'


## note: pass in nytimes, lang, etc for multi-site
News.site = ARGV[0]   if ARGV.size > 0



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
puts "This Quartal: #{News.this_quarter.count}"
puts "This Month:   #{News.this_month.count}"
puts "This Week:    #{News.this_week.count}"
puts "Today:        #{News.today.count}"
puts

puts "100 Latest News Items"
News.latest.limit( 100 ).each do |item|
  print "%4dd " % (Date.today.jd-item.updated.to_date.jd)
  print "  #{item.updated}"
  print " - #{item.title}"
  print " - #{URI(item.feed.feed_url).host}"   ## fix: use feed.url / title or something
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
  print " - #{channel.feed_url}"   ## fix: use feed title or something
  print "\n"
end




