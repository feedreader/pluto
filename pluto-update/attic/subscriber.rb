

  def update_subscriptions( config, opts={} )
    # !!!! -- deprecated API - remove - do NOT use anymore
    logger.warn "*** [Pluto::Subscriber] deprecated API -- use update_subscriptions_for( site_key )"
    update_subscriptions_for( 'planet', config, opts )  # default to planet site_key
  end
