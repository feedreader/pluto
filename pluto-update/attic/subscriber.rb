

  def update_subscriptions( config, opts={} )
    # !!!! -- depreciated API - remove - do NOT use anymore
    puts "*** warn - [Pluto::Subscriber] depreciated API -- use update_subscriptions_for( site_key )"
    update_subscriptions_for( 'planet', config, opts )  # default to planet site_key
  end


