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
    order( "coalesce(last_published,'1971-01-01') desc" )
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

end  # class Feed


  end # module Models
end # module Pluto
