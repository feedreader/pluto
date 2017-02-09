

desc 'pluto -=- setup/update feed subscriptions'
task :setup => :environment do

  ## check if PLANET key passed in
  if ENV['PLANET'].present?
    key = ENV['PLANET']
    puts "setup planet for key >#{key}<"
  else
    puts 'no PLANET=key passed along; try defaults'
    # try pluto.yml or planet.yml if exist

    if File.exists?( './pluto.ini' ) # check if pluto.ini exists, if yes add/use it
      key ='pluto'
    elsif File.exists?( './planet.ini' )  # check if planet.ini exists, if yes add/use it
      key = 'planet'
    else
      puts '*** error: no arg passed in; no pluto.ini or planet.ini found in working folder'
      exit 1
    end
  end


  config_path = "./#{key}.ini"
  if File.exists?( config_path )
    config = INI.load_file( config_path )
 
    puts "dump planet setup settings:"
    pp config
    # note: allow multiple planets (sites) for a single install
    Pluto::Model::Site.deep_create_or_update_from_hash!( key, config )

  else  ## try download shortcut index list and fetch planet config
    Pluto.setup_planet( key )
  end

  puts 'Done.'
end

