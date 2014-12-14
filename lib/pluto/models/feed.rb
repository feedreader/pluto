# encoding: utf-8


module Pluto
  module Model

class Feed < ActiveRecord::Base
  self.table_name = 'feeds'

  has_many :items
  has_many :subscriptions
  has_many :sites, :through => :subscriptions


  ## todo/fix:
  ##  use a module ref or something; do NOT include all methods - why? why not? 
  include TextUtils::HypertextHelper   ## e.g. lets us use strip_tags( ht )


  def self.latest
    # note: order by first non-null datetime field
    #   coalesce - supported by sqlite (yes), postgres (yes)

    # note: if not published, touched or built use hardcoded 1971-01-01 for now
    ## order( "coalesce(published,touched,built,'1971-01-01') desc" )
    order( "coalesce(feeds.last_published,'1971-01-01') desc" )
  end

  ##################################
  # attribute reader aliases
  #
  #  todo: check if we can use alias_method :name, :title   - works for non-existing/on-demand-generated method too??

  def name()        title;    end  # alias for title
  def description() summary;  end  # alias for summary  -- also add descr shortcut??
  def link()        url;      end  # alias for url
  def feed()        feed_url; end  # alias for feed_url

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

    ## todo: move to FeedUtils::Feed ??? why? why not??
    if data.generator
      generator_full = ''
      generator_full << data.generator
      generator_full << " @version=#{data.generator_version}"   if data.generator_version
      generator_full << " @uri=#{data.generator_uri}"           if data.generator_uri
    else
      generator_full = nil
    end

##
# todo:
##  strip all tags from title2
##  limit to 255 chars
## e.g. title2 such as this exist
##  This is a low-traffic announce-only list for people interested
##  in hearing news about Polymer (<a href="http://polymer-project.org">http://polymer-project.org</a>).
## The higher-traffic mailing list for all kinds of discussion is
##  <a href="https://groups.google.com/group/polymer-dev">https://groups.google.com/group/polymer-dev</a>


    feed_attribs = {
        format:       data.format,
        published:    data.published,
        touched:      data.updated,
        built:        data.built,
        summary:      data.summary,
        ### todo/fix: add/use
        # auto_title:     ???,
        # auto_url:       ???,
        # auto_feed_url:  ???,
        auto_title2:  data.title2 ? strip_tags(data.title2)[0...255] : data.title2,   # limit to 255 chars; strip tags
        generator:    generator_full
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


  end # module Model
end # module Pluto
