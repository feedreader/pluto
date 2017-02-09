

desc 'pluto - show planet (feed) stats'
task :stats => :environment do
  puts "stats:"
  puts "  Feeds: #{Pluto::Model::Feed.count}"
  puts "  Items: #{Pluto::Model::Item.count}"
  puts "  Sites: #{Pluto::Model::Site.count}"
  puts "  Subscriptions:  #{Pluto::Model::Subscription.count}"
end

