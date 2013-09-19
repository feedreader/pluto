
###########################
# todo: move to feedutils

module FeedUtils


  class Feed
    attr_accessor :object

    attr_accessor :format   # e.g. atom|rss 2.0|etc.
    attr_accessor :title
    attr_accessor :title_type  # e.g. text|html  (optional) -use - why?? why not??
    
    attr_accessor :items
    
    def self.create( feed_wild )
      
      puts "  feed.class=#{feed_wild.class.name}"
 
      if feed_wild.class == RSS::Atom::Feed   ## fix: use feed_wild.kind_of?( RSS::Atom::Feed )
        feed = self.create_from_atom( feed_wild )
      else  ## assume RSS::Rss::Feed
        feed = self.create_from_rss( feed_wild )
      end
        
      puts "== #{feed.format} / #{feed.title} =="
      feed
    end

    def self.create_from_atom( atom_feed )
      feed = Feed.new
      feed.object = atom_feed
      feed.title  = atom_feed.title.content
      feed.format = 'atom'

      items = []
      atom_feed.items.each do |atom_item|
        items << Item.create_from_atom( atom_item )
      end
      feed.items = items

      feed # return new feed
    end

    def self.create_from_rss( rss_feed )
      feed = Feed.new
      feed.object = rss_feed
      feed.title  = rss_feed.channel.title
      feed.format = "rss #{rss_feed.rss_version}"
  
      items = []
      rss_feed.items.each do |rss_item|
        items << Item.create_from_rss( rss_item )
      end
      feed.items = items

      feed # return new feed
    end

  end  # class Feed



  class Item
    attr_accessor :object   # orginal object (e.g RSS item or ATOM entry etc.)

    attr_accessor :title
    attr_accessor :title_type    # optional for now (text|html) - not yet set
    attr_accessor :url      # todo: rename to link (use alias) ??
    attr_accessor :content
    attr_accessor :content_type  # optional for now (text|html) - not yet set

## todo: add summary (alias description)  ???
## todo: add author/authors
## todo: add category/categories

    attr_accessor :updated
    attr_accessor :published

    attr_accessor :guid     # todo: rename to id (use alias) ??


    def self.create_from_atom( atom_item )
      item = self.new   # Item.new
      item.object = atom_item

      item.title     = atom_item.title.content
      item.url       = atom_item.link.href
        
      ## todo: check if updated or published present
      #    set 
      item.updated    =  atom_item.updated.content.utc.strftime( "%Y-%m-%d %H:%M" )
      item.published  =  item.updated  # fix: check if publshed set

      item.guid       =  atom_item.id.content


      # todo: move logic to updater or something
      #  - not part of normalize
        
      if atom_item.summary
        item.content = atom_item.summary.content
      else
        if atom_item.content
          text  = atom_item.content.content.dup
          ## strip all html tags
          text = text.gsub( /<[^>]+>/, '' )
          text = text[ 0..400 ] # get first 400 chars
          ## todo: check for length if > 400 add ... at the end???
          item.content = text
        end
      end

      puts "- #{atom_item.title.content}"
      puts "  link >#{atom_item.link.href}<"
      puts "  id (~guid) >#{atom_item.id.content}<"
        
      ### todo: use/try published first? why? why not?
      puts "  updated (~pubDate) >#{atom_item.updated.content}< >#{atom_item.updated.content.utc.strftime( "%Y-%m-%d %H:%M" )}< : #{atom_item.updated.content.class.name}"
      puts
        
      # puts "*** dump item:"
      # pp item

      item
    end # method create_from_atom

    def self.create_from_rss( rss_item )

      item = self.new    # Item.new
      item.object = rss_item

      item.title     = rss_item.title
      item.url       = rss_item.link
      
      ## todo: check if updated or published present
      #    set 
      item.published = rss_item.pubDate.utc.strftime( "%Y-%m-%d %H:%M" )
      item.updated   = item.published
      
      # content:  item.content_encoded,
  
        # if item.content_encoded.nil?
          # puts " using description for content"
       
      item.content  = rss_item.description
        # end
        
      item.guid     = rss_item.guid.content
        
      puts "- #{rss_item.title}"
      puts "  link (#{rss_item.link})"
      puts "  guid (#{rss_item.guid.content})"
      puts "  pubDate >#{rss_item.pubDate}< >#{rss_item.pubDate.utc.strftime( "%Y-%m-%d %H:%M" )}< : #{rss_item.pubDate.class.name}"
      puts

      # puts "*** dump item:"
      # pp item

      item
    end # method create_from_rss

  end  # class Item


  class Parser

    ### Note: lets keep/use same API as RSS::Parser for now
    def initialize( xml )
      @xml = xml
    end
    
    def parse
 
      parser = RSS::Parser.new( @xml )
      parser.do_validate            = false
      parser.ignore_unknown_element = true

      puts "Parsing feed..."
      feed_wild = parser.parse  # not yet normalized
 
      feed = Feed.create( feed_wild )
      feed # return new (normalized) feed
    end
 
  end  # class Parser


end # module FeedUtils
