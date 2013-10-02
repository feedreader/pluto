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

    # note: if not published_at,touched_at or built_at use hardcoded 1911-01-01 for now
    ## order( "coalesce(published_at,touched_at,built_at,'1911-01-01') desc" )
    order( "coalesce(latest_published_at,'1911-01-01') desc" )
  end

  ##################################
  # attribute reader aliases
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


  def published_at?()  read_attribute(:published_at).present?;  end
  def touched_at?()    read_attribute(:touched_at).present?;    end

  def published_at
    ## todo/fix: use a new name - do NOT squeeze convenience lookup into existing
    #    db backed attribute

    read_attribute_w_fallbacks(
       :published_at,  # try touched_at (aka updated (ATOM))
       :touched_at,    # try build_at (aka lastBuildDate (RSS))
       :built_at
    )
  end

end  # class Feed


  end # module Models
end # module Pluto
