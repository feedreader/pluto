module Pluto
  module Models

class ItemCursor

  def initialize( items )
    @items = items
  end

  def each
    last_published_at = Time.local( 1911, 1, 1 )
    last_feed_id      = -1     ## todo: use feed_key instead of id?? why? why not??
    
    @items.each do |item|

      item_published_at = item.published_at  # cache published_at value ref

      if last_published_at.year   == item_published_at.year  &&
         last_published_at.month  == item_published_at.month &&
         last_published_at.day    == item_published_at.day 
        new_date = false
      else
        new_date = true
      end

      if last_feed_id == item.feed.id
        new_feed = false
      else
        new_feed = true
      end

      yield( item, new_date, new_feed )
      
      last_published_at = item.published_at
      last_feed_id      = item.feed.id
    end
  end # method each
    
end # class ItemCursor


  end # module Models
end # module Pluto
