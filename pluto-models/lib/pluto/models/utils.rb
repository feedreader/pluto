# frozen_string_literal: true

module Pluto
  module Model
    class ItemCursor
      def initialize(items)
        @items = items
      end

      def each
        last_updated      = Time.local(1970, 1, 1)
        last_feed_id      = -1 ## todo: use feed_key instead of id?? why? why not??

        @items.each do |item|
          item_updated = item.updated # cache updated value ref

          new_date = if last_updated.year == item_updated.year &&
                        last_updated.month  == item_updated.month &&
                        last_updated.day    == item_updated.day
                       false
                     else
                       true
                     end

          ## note:
          #   new date also **always** starts new feed
          #  - e.g. used for grouping within day (follows planet planet convention)

          new_feed = if new_date || last_feed_id != item.feed.id
                       true
                     else
                       false
                     end

          yield(item, new_date, new_feed)

          last_updated   = item.updated
          last_feed_id   = item.feed.id
        end
      end
    end
  end
end
