

desc 'pluto -=- update planet (site configs)'
task :update_sites => :env do

  Pluto.update_sites  # update all site configs if source (url) present/specified

  puts 'Done (Update Sites).'
end


desc 'pluto -=- update planet (feeds)'
task :update_feeds => :env do

  Pluto.update_feeds
  
  puts 'Done (Update Feeds).'
end


desc 'pluto -=- update planet (site configs + feeds)'
task :update => [:update_sites, :update_feeds] do
  puts 'Done.'
end
