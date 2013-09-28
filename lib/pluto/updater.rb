module Pluto

class Updater

  include LogUtils::Logging

  def initialize( opts, config )
    @opts    = opts
    @config  = config
  end

  attr_reader :opts, :config

  def run
    ###################
    # step 1) update subscriptions
    subscriber = Subscriber.new

    # pass along debug/verbose setting/switch
    subscriber.debug = true    if opts.verbose?
    subscriber.update_subscriptions( config )

    ##############################
    # step 2) update feeds
    refresher = Refresher.new

    # pass along debug/verbose setting/switch
    refresher.debug = true    if opts.verbose?
    refresher.update_feeds
  end # method run

end # class Updater

end # module Pluto
