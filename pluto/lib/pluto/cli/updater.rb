# encoding: utf-8



module Pluto

class Updater

  include LogUtils::Logging

  ### fix!!!!!: change config    to text   - yes/no - why? why not??
  #   or pass along struct
  #      - with hash and text and format(e.g. ini) as fields???
  #
  #   - why? - we need to get handle on md5 digest/hash plus on plain text, ideally to store in db
  ##  - pass along unparsed text!! - not hash struct
  #      - will get saved in db plus we need to generate md5 hash
  #    - add filename e.g. ruby.ini|ruby.conf as opt ??
  #           or add config format as opt e.g. ini?

  def initialize( opts, config )
    @opts    = opts
    @config  = config
  end

  attr_reader :opts, :config

  def run( arg )
    arg = arg.downcase.gsub('.ini','')  # remove file extension if present

    update_for( arg )
  end

  def update_for( name )

    ## note: allow (optional) config of site key too
    site_key = config['key'] || config['slug']
    if site_key.nil?
      ## if no key configured; use (file)name; remove -_ chars
      ##   e.g. jekyll-meta becomes jekyllmeta etc.
      site_key = name.downcase.gsub( /[\-_]/, '' )
    end

    ###################
    # step 1) update site subscriptions
    Model::Site.deep_create_or_update_from_hash!( site_key, config )

    ##############################
    # step 2) update feeds
    feed_refresher = FeedRefresher.new
    feed_refresher.refresh_feeds_for( site_key )
  end # method run

end # class Updater

end # module Pluto
