module Pluto

class Subscriber

  include LogUtils::Logging

  include Models

  def debug=(value)  @debug = value;   end
  def debug?()       @debug || false;  end


  def update_subscriptions( config, opts={} )

    site_attribs = {
      title: config[ 'title' ] || config[ 'name' ]   # support either title or name
    }

    ## for now - use single site w/ key planet
    ##  -- fix!! allow multiple sites (planets)
    
    site_key = 'planet'
    site_rec = Site.find_by_key( site_key )
    if site_rec.nil?
      site_rec             = Site.new
      site_attribs[ :key ] = site_key

      ## use object_id: site.id and object_type: Site
      ## change - model/table/schema!!!
      Action.create!( title: 'new site', object: site_attribs[ :title ] )
    end
    site_rec.update_attributes!( site_attribs )

    # -- log update action
    Action.create!( title: 'update subscriptions' )

    # clean out subscriptions and add again
    logger.debug "before site.subscriptions.delete_all - count: #{site_rec.subscriptions.count}"
    site_rec.subscriptions.destroy_all  # note: use destroy_all NOT delete_all (delete_all tries by default only nullify)
    logger.debug "after site.subscriptions.delete_all - count: #{site_rec.subscriptions.count}"

    config.each do |key, value|

      ## todo: downcase key - why ??? why not???

      # skip "top-level" feed keys e.g. title, etc. or planet planet sections (e.g. planet,defaults)
      next if ['title','title2','name','feeds','planet','defaults'].include?( key )   

      ### todo/check:
      ##   check value - must be hash
      #     check if url or feed_url present
      #      that is, check for required props/key-value pairs

      feed_key   = key.to_s.dup
      feed_hash  = value

      # todo: use title from feed?
      feed_attribs = {
        feed_url: feed_hash[ 'feed' ]  || feed_hash[ 'feed_url' ],
        url:      feed_hash[ 'link' ]  || feed_hash[ 'url' ],
        title:    feed_hash[ 'title' ] || feed_hash[ 'name' ],
        title2:   feed_hash[ 'title2' ]
      }

      puts "Updating feed subscription >#{feed_key}< - >#{feed_attribs[:feed_url]}<..."

      feed_rec = Feed.find_by_key( feed_key )
      if feed_rec.nil?
        feed_rec             = Feed.new
        feed_attribs[ :key ] = feed_key

        ## use object_id: feed.id and object_type: Feed
        ## change - model/table/schema!!!
        ## todo: add parent_action_id - why? why not?
        Action.create!( title: 'new feed', object: feed_attribs[ :title ] )
      end
      
      feed_rec.update_attributes!( feed_attribs )

      #  add subscription record
      #   note: subscriptions get cleaned out on update first (see above)
      site_rec.subscriptions.create!( feed_id: feed_rec.id )   
    end

  end # method update_subscriptions

end # class Subscriber

end # module Pluto
