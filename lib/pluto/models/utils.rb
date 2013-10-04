module Pluto
  module Models

class ItemCursor

  def initialize( items )
    @items = items
  end

  def each
    last_published = Time.local( 1971, 1, 1 )
    last_feed_id      = -1     ## todo: use feed_key instead of id?? why? why not??
    
    @items.each do |item|

      item_published = item.published  # cache published value ref

      if last_published.year   == item_published.year  &&
         last_published.month  == item_published.month &&
         last_published.day    == item_published.day 
        new_date = false
      else
        new_date = true
      end

## note:
#   new date also **always** starts new feed
#  - e.g. used for grouping within day (follows planet planet convention)

      if new_date || last_feed_id != item.feed.id 
        new_feed = true
      else
        new_feed = false
      end

      yield( item, new_date, new_feed )

      last_published = item.published
      last_feed_id   = item.feed.id
    end
  end # method each
    
end # class ItemCursor


  end # module Models
end # module Pluto
