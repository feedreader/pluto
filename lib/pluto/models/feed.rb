module Pluto
  module Models

class Feed < ActiveRecord::Base
  self.table_name = 'feeds'

  include Pluto::ActiveRecordMethods  # e.g. read_attribute_w_fallbacks

  has_many :items
  has_many :subscriptions
  has_many :sites, :through => :subscriptions


  def self.latest
    # note: order by first non-null datetime field
    #   coalesce - supported by sqlite (yes), postgres (yes)

    # note: if not published, touched or built use hardcoded 1971-01-01 for now
    ## order( "coalesce(published,touched,built,'1971-01-01') desc" )
    order( "coalesce(feeds.last_published,'1971-01-01') desc" )
  end

  ##################################
  # attribute reader aliases
  def name()        title;    end  # alias for title
  def description() summary;  end  # alias for summary  -- also add descr shortcut??
  def link()        url;      end  # alias for url
  def feed()        feed_url; end  # alias for feed_url

  def last_published_at() last_published; end # legay attrib reader - depreciated - remove!!
  def fetched_at()        fetched;        end # legay attrib reader - depreciated - remove!!
  def published_at()      published;      end # legay attrib reader - depreciated - remove!!
  def touched_at()        touched;        end # legay attrib reader - depreciated - remove!!
  def built_at()          built;          end # legay attrib reader - depreciated - remove!!


  def url?()           read_attribute(:url).present?;       end
  def title?()         read_attribute(:title).present?;     end
  def title2?()        read_attribute(:title2).present?;    end
  def feed_url?()      read_attribute(:feed_url).present?;  end

  def url()      read_attribute_w_fallbacks( :url,      :auto_url );      end
  def title()    read_attribute_w_fallbacks( :title,    :auto_title );    end
  def title2()   read_attribute_w_fallbacks( :title2,   :auto_title2 );   end
  def feed_url() read_attribute_w_fallbacks( :feed_url, :auto_feed_url ); end


  def published?()  read_attribute(:published).present?;  end
  def touched?()    read_attribute(:touched).present?;    end


  def published
    ## todo/fix: use a new name - do NOT squeeze convenience lookup into existing
    #    db backed attribute

    read_attribute_w_fallbacks(
       :published,  
       :touched,     # try touched (aka updated (ATOM))
       :built        # try build (aka lastBuildDate (RSS))
    )
  end


  def debug=(value)  @debug = value;   end
  def debug?()       @debug || false;  end

  def save_from_struct!( data )

    update_from_struct!( data )
    
    data.items.each do |item|

      item_rec = Item.find_by_guid( item.guid )
      if item_rec.nil?
        item_rec  = Item.new
        puts "** NEW | #{item.title}"
      else
        ## todo: check if any attribs changed
        puts "UPDATE | #{item.title}"
      end
      
      item_rec.debug = debug? ? true : false  # pass along debug flag
      item_rec.update_from_struct!( self, item )

    end  # each item
  end


  def update_from_struct!( data )
    feed_attribs = {
        format:       data.format,
        published:    data.published? ? data.published : nil,
        touched:      data.updated?   ? data.updated   : nil,
        built:        data.built?     ? data.built     : nil,
        summary:      data.summary?   ? data.summary   : nil,
        ### todo/fix: add/use
        # auto_title:     ???,
        # auto_url:       ???,
        # auto_feed_url:  ???,
        auto_title2:  data.title2?    ? data.title2    : nil,
        generator:    data.generator
      }

    if debug?
        ## puts "*** dump feed_attribs:"
        ## pp feed_attribs
        puts "*** dump feed_attribs w/ class types:"
        feed_attribs.each do |key,value|
          puts "  #{key}: >#{value}< : #{value.class.name}"
        end
    end

    update_attributes!( feed_attribs )
  end

end  # class Feed


  end # module Models
end # module Pluto
