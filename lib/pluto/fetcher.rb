module Pluto


class Fetcher

  include LogUtils::Logging

  def initialize( opts, config )
    @opts    = opts
    @config  = config
  end

  attr_reader :opts, :config


  def run

    updater = Updater.new

    # pass along debug/verbose setting/switch
    updater.debug = true    if opts.verbose?

    updater.update_subscriptions( config )
    updater.update_feeds

  end # method run


end # class Fetcher

end # module Pluto
