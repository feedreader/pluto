module Pluto


class Fetcher

  def initialize( logger, opts, config )
    @logger  = logger
    @opts    = opts
    @config  = config
  end

  attr_reader :logger, :opts, :config

  
  def run
    worker = ::Fetcher::Worker.new( logger )

    config[ 'feeds' ].each do |feed_key|
      
      feed_hash  = config[ feed_key ]
      feed_url   = feed_hash[ 'feed_url' ]
      
      puts "Fetching feed >#{feed_key}< using >#{feed_url}<..."

      feed_rec = Feed.find_by_key( feed_key )
      if feed_rec.nil?
        feed_rec      = Feed.new
        feed_rec.key  = feed_key
      end
      feed_rec.feed_url = feed_url
      feed_rec.url      = feed_hash[ 'url' ]
      feed_rec.title    = feed_hash[ 'title' ]    # todo: use title from feed?
      feed_rec.save!

      worker.copy( feed_url, "./#{feed_key}.xml" )
    end

    logger.debug "RSS::VERSION #{RSS::VERSION}"
    
    config[ 'feeds' ].each do |feed_key|
      
      feed_hash = config[ feed_key ]
      feed_rec  = Feed.find_by_key!( feed_key )

      xml = File.read( "./#{feed_key}.xml" )
      
      puts "Before parsing feed >#{feed_key}<..."

      parser = RSS::Parser.new( xml )
      parser.do_validate            = false
      parser.ignore_unknown_element = true

      puts "Parsing feed >#{feed_key}<..."
      feed = parser.parse
      puts "After parsing feed >#{feed_key}<..."
      
      puts "feed.class=#{feed.class.name}"


      if feed.class == RSS::Atom::Feed
         puts "== #{feed.title.content} =="  
      else  # assume RSS::Rss
         puts "==  #{feed.channel.title} =="
      end
      
      feed.items.each do |item|

        if feed.class == RSS::Atom::Feed

        ## todo: if content.content empty use summary for example
        item_attribs = {
          :title        => item.title.content,
          :url          => item.link.href,
          :published_at => item.updated.content,
          # :content      => item.content.content,
          :feed_id      => feed_rec.id
        }
        guid = item.id.content

        puts "- #{item.title.content}"
        puts "  link >#{item.link.href}<"
        puts "  id (~guid) >#{item.id.content}<"
        
        ### todo: use/try published first? why? why not?
        puts "  updated (~pubDate) >#{item.updated.content}< : #{item.updated.content.class.name}"
        puts
        
        else  # assume RSS::Rss
        item_attribs = {
          :title        => item.title,
          :url          => item.link,
          :published_at => item.pubDate,
          :content      => item.content_encoded,
          :feed_id      => feed_rec.id
        }
        guid = item.guid.content
        
        puts "- #{item.title}"
        puts "  link (#{item.link})"
        puts "  guid (#{item.guid.content})"
        puts "  pubDate (#{item.pubDate}) : #{item.pubDate.class.name}"
        puts

        end
        
        rec = Item.find_by_guid( guid )
        if rec.nil?
          rec      = Item.new
          rec.guid = guid
        end
                
        rec.update_attributes!( item_attribs )
        
        # puts "*** dump item:"
        # pp item
        
        end  # each item
    end # each feed

  end # method run

end # class Fetcher

end # module Pluto
