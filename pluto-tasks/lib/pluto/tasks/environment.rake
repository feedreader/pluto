

###
# Note: check if running as part of Rails? if yes - use (builtin) rails :environment task/dependency


if defined?( Rails )
  ### todo:
  ## check if task :environment exists? in rake - why? why not?

  ## do nothing; use "builtin" :environment task
  ##   to setup database connection etc.
else
  task :environment do
    LogUtils::Logger.root.level = :debug

    Pluto.connect!
  end
end



#########
# for debugging

desc 'pluto - debug site setup'
task :site => :environment do
  site = Pluto::Model::Site.first      # FIX: for now assume one planet per DB (fix later; allow planet key or similar)
  if site.present?
    puts "site found:"
    pp site
  else
    puts "no site found"
  end
end

### todo: add new task :sites

