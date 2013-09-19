module Pluto

class Updater

  include LogUtils::Logging

  include Models

  def initialize
    @worker  = ::Fetcher::Worker.new
  end

  attr_reader :worker

  def debug=(value)
    @debug = value
    ### logger.debug "[Updater] setting debug flag - debug? #{debug?}"
  end

  def debug?
    @debug || false
  end

  def fetch_feed( url )
    xml = worker.read( url )

    ###
    # NB: Net::HTTP will NOT set encoding UTF-8 etc.
    # will mostly be ASCII
    # - try to change encoding to UTF-8 ourselves
    logger.debug "xml.encoding.name (before): #{xml.encoding.name}"

    #####
    # NB: ASCII-8BIT == BINARY == Encoding Unknown; Raw Bytes Here

    ## NB:
    # for now "hardcoded" to utf8 - what else can we do?
    # - note: force_encoding will NOT change the chars only change the assumed encoding w/o translation
    xml = xml.force_encoding( Encoding::UTF_8 )
    logger.debug "xml.encoding.name (after): #{xml.encoding.name}"      
    xml
  end


  def update_subscriptions( config, opts={} )

    ## for now - use single site w/ key planet  -- fix!! allow multiple sites (planets)
    
    site_attribs = {
      title: config[ 'title' ]
    }
    
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


    config[ 'feeds' ].each do |feed_key|
      
      feed_hash  = config[ feed_key ]

      feed_attribs = {
        feed_url: feed_hash[ 'feed_url' ],
        url:      feed_hash[ 'url'      ],
        title:    feed_hash[ 'title'    ]   # todo: use title from feed?
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
      
      ## todo:
      #  add subscription records  (feed,site)  - how? 
    end

  end # method update_subscriptions


  def update_feeds( opts={} )

    ### move to feedutils
    ### logger.debug "using stdlib RSS::VERSION #{RSS::VERSION}"

    # -- log update action
    Action.create!( title: 'update feeds' )

    Feed.all.each do |feed_rec|

      feed_key = feed_rec.key
      feed_url = feed_rec.feed_url
      
      feed_xml = fetch_feed( feed_url )

      logger.debug "feed_xml:"
      logger.debug feed_xml[ 0..300 ] # get first 300 chars

      #  if opts.verbose?  # also write a copy to disk
      if debug?
        logger.debug "saving feed to >./#{feed_key}.xml<..."
        File.open( "./#{feed_key}.xml", 'w' ) do |f|
          f.write( feed_xml )
        end
      end
      
      puts "Before parsing feed >#{feed_key}<..."

      feed = FeedUtils::Parser.new( feed_xml ).parse

      feed.items.each do |item|

        item_attribs = {
          title:        item.title,
          url:          item.url,
          content:      item.content,
          published_at: item.published,
          feed_id:      feed_rec.id    # add feed_id fk_ref
        }

        rec = Item.find_by_guid( item.guid )
        if rec.nil?
          rec      = Item.new
          item_attribs[ :guid ] = item.guid
          puts "** NEW"
        else
          ## todo: check if any attribs changed
          puts "UPDATE"
        end
                
        rec.update_attributes!( item_attribs )
      end  # each item

    end # each feed

  end # method run


 
end # class Fetcher

end # module Pluto
