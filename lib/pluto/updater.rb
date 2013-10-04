module Pluto

class Updater

  include LogUtils::Logging

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
