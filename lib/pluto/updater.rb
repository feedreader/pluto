module Pluto

class Updater

  include LogUtils::Logging

  ### fix!!!!!: change config    to text   - yes/no - why? why not??
  #   or pass along struct
  #      - with hash and text and format(e.g. ini/yml) as fields???
  #
  #   - why? - we need to get handle on md5 digest/hash plus on plain text, ideally to store in db
  ##  - pass along unparsed text!! - not hash struct
  #      - will get saved in db plus we need to generate md5 hash
  #    - add filename e.g. ruby.ini|ruby.conf|ruby.yml as opt ??
  #           or add config format as opt e.g. ini or yml?

  def initialize( opts, config )
    @opts    = opts
    @config  = config
  end

  attr_reader :opts, :config

  def run( arg )
    arg = arg.downcase.gsub('.ini','').gsub('.yml','')  # remove file extension if present

    update_for( arg )
  end

  def update_for( site_key )
    ###################
    # step 1) update subscriptions
    subscriber = Subscriber.new

    # pass along debug/verbose setting/switch
    subscriber.debug = true    if opts.verbose?
    subscriber.update_subscriptions_for( site_key, config )

    ##############################
    # step 2) update feeds
    refresher = Refresher.new

    # pass along debug/verbose setting/switch
    refresher.debug = true    if opts.verbose?
    refresher.update_feeds_for( site_key )
  end # method run

end # class Updater

end # module Pluto
