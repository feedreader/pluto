

task :env  do
  LogUtils::Logger.root.level = :debug

  Pluto.connect!
end


#########
# for debugging

desc 'pluto - debug site setup'
task :site => :env do
  site = Pluto::Models::Site.first      # FIX: for now assume one planet per DB (fix later; allow planet key or similar)
  if site.present?
    puts "site found:"
    pp site
  else
    puts "no site found"
  end
end

### todo: add new task :sites

