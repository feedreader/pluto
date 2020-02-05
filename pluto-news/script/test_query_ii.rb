###
#  to run use
#     ruby -I ./lib script/test_query_ii.rb


require 'pluto/news'


puts ":::::::::::::::::::::::::::::::::::::::::::::::::::"
puts ":: #{News.items.count} news items from #{News.channels.count} channels:"
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
  print " - #{channel.feed_url}"
  print "\n"

  ## remove body (feed body content for now
  ##   note: string required; NOT working with symbol :body)
  h = channel.attributes.dup
  h.delete( 'body' )
  pp h
  puts
end





