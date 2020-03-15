require 'newscast'



News.config.database = './news.db'

puts "::::::::::::::::::::::::::::::::::::"
puts "::  #{News.channels.count} channels, #{News.items.count} items"


puts
puts "Channels"
News.channels.reorder( 'items_last_updated DESC' ).each do |channel|

  dates = channel.items.reduce( [] ) do |ary,item|
    if item.published
      ary << item.published.to_date.jd
    end
    ary
  end
  dates = dates.sort.reverse

  diff = channel.items.count - dates.size
  if diff > 0
    puts "!!!! WARN - #{diff} dates missing !!!!"
  end

  days_diff =    if dates.size > 1
                      "#{dates[0] - dates[-1]}d"
                 else
                      '?'
                 end


  if channel.items_last_updated?
    print "%4dd " % (Date.today.jd-channel.items_last_updated.to_date.jd)
  else
    print "   ?  "
  end
  print "  #{channel.items_last_updated}"
  print " - %4d" % channel.items.count
  print " (#{days_diff})"
  print " - #{channel.title}"
  print " @ #{channel.feed_url}"
  print "\n"

  if channel.updated?
    print "%4dd " % (Date.today.jd-channel.updated.to_date.jd)
  else
    print "   ?  "
  end
  print "   >#{channel.data.updated}<"     # from feed updated(atom) + lastBuildDate(rss)
  print " / >#{channel.data.published}<"   # from feed published(atom) + pubDate(rss) - note: published basically an alias for created
  print "   -- #{channel.format} >#{channel.generator}<"
  print " @ >#{channel.http_server}<"
  print "\n"


  channel.items.latest.limit(6).each do |item|
    print "  * "
    if item.updated?
      print "%4dd " % (Date.today.jd-item.updated.to_date.jd)
    else
      print "   ?  "
    end

    print "  >#{item.data.updated}<"
    print "  >#{item.data.published}<"
    print "  - >#{item.title}<"
    print "\n"
  end

  puts
end


