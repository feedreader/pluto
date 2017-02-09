# encoding: utf-8


require 'pluto/models'
require 'pluto/update'


# our own code

require 'pluto/tasks/version'   # note: let version always get first




#############
### todo/fix: use/find better name? - e.g. Fetcher.read_utf8!()  move out of global ns etc.
###   e.g. use Fetch.read_utf8!()  e.g. throws exception on error
##                   read_blob!()
def fixme_fetcher_read_utf8!( src )
  worker = Fetcher::Worker.new
  res = worker.get_response( src )
  if res.code != '200'
    puts "sorry; failed to fetch >#{src} - HTTP #{res.code} - #{res.message}"
    exit 1
  end

  ###
  # Note: Net::HTTP will NOT set encoding UTF-8 etc.
  #  will be set to ASCII-8BIT == BINARY == Encoding Unknown; Raw Bytes Here
  #  thus, set/force encoding to utf-8
  txt = res.body.to_s
  txt = txt.force_encoding( Encoding::UTF_8 )
  txt
end



module Pluto

  def self.load_tasks
    # load all builtin Rake tasks (from tasks/*rake)
    load 'pluto/tasks/environment.rake'
    load 'pluto/tasks/setup.rake'
    load 'pluto/tasks/stats.rake'
    load 'pluto/tasks/update.rake'
  end



  ###
  ##  todo/fix: move to pluto-update for (re)use !!!!
  def self.no_longer_used__fetch_config_for__delete_why_why_not( key )
    ###
    ## todo:
    ##  move into a method for (re)use
    puts "trying to fetch pluto.index.ini shortcut planet registry..."

    index_txt = fixme_fetcher_read_utf8!( 'https://raw.githubusercontent.com/feedreader/planets/master/pluto.index.ini' )
    shortcuts = INI.load( index_txt )
    pp shortcuts

    shortcut = shortcuts[key]
    if shortcut.nil?
      puts "sorry; no planet shortcut found for key >#{key}<"
      exit 1
    end

    config_txt = InclPreproc.from_url( shortcut['source'] ).read
    config = INI.load( config_txt )
    config
  end # method fetch_config_for


  ## todo: use a better name? setup_planet_for ?? other name??
  def self.setup_planet( key )
    puts "trying to fetch pluto.index.ini shortcut planet registry..."

    index_txt = fixme_fetcher_read_utf8!( 'https://raw.githubusercontent.com/feedreader/planets/master/planets.ini' )
    shortcuts = INI.load( index_txt )
    pp shortcuts

    shortcut = shortcuts[key]
    if shortcut.nil?
      puts "sorry; no planet shortcut found for key >#{key}<"
      exit 1
    end

    i=1
    loop do
      config_url = shortcut[ "source#{i}" ]
      break if config_url.nil?

      ## "calc" key from url
      #    https://raw.github.com/feedreader/planet-ruby/gh-pages/ruby-news.ini
      # get last entry e.g. ruby-news.ini
      ##   remove -_ chars
      ## e.g. jekyll-meta becomes jekyllmeta etc.

      config_key = config_url[ (config_url.rindex('/')+1)..-1 ]
      config_key = config_key.sub( '.ini', '' )    # remove .ini extension
      config_key = config_key.gsub( /[\-_]/, '' )  # remove -_ chars

      config_txt = InclPreproc.from_url( config_url ).read
      config = INI.load( config_txt )

      puts "dump planet setup settings:"
      pp config
      # note: allow multiple planets (sites) for a single install
      Pluto::Model::Site.deep_create_or_update_from_hash!( config_key, config )

      i+=1
    end
  end # method setup_planet

end  # module Pluto




# say hello
puts PlutoTasks.banner   if $DEBUG || (defined?($RUBYLIBS_DEBUG) && $RUBYLIBS_DEBUG) 
