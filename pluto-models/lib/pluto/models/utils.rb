# encoding: utf-8

module Pluto
  module Model

class ItemCursor

  def initialize( items )
    @items = items
  end

  def each
    last_updated      = Time.local( 1970, 1, 1 )
    last_feed_id      = -1     ## todo: use feed_key instead of id?? why? why not??

    @items.each do |item|

      item_updated = item.updated  # cache updated value ref

      if last_updated.year   == item_updated.year  &&
         last_updated.month  == item_updated.month &&
         last_updated.day    == item_updated.day
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

      last_updated   = item.updated
      last_feed_id   = item.feed.id
    end
  end # method each

end # class ItemCursor


  end # module Model
end # module Pluto
