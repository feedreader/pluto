

desc 'pluto - show planet (feed) stats'
task :stats => :env do
  puts "stats:"
  puts "  Feeds: #{Pluto::Models::Feed.count}"
  puts "  Items: #{Pluto::Models::Item.count}"
  puts "  Sites: #{Pluto::Models::Site.count}"
  puts "  Subscriptions:  #{Pluto::Models::Subscription.count}"
end
