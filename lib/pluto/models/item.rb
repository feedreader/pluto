module Pluto
  module Models

class Item < ActiveRecord::Base
  self.table_name = 'items'

  include Pluto::ActiveRecordMethods  # e.g. read_attribute_w_fallbacks

  belongs_to :feed
  
  def self.latest
    # note: order by first non-null datetime field
    #   coalesce - supported by sqlite (yes), postgres (yes)

    # note: if not published_at,touched_at or built_at use hardcoded 1911-01-01 for now
    order( "coalesce(published_at,touched_at,'1911-01-01') desc" )
  end

  def published_at?()  read_attribute(:published_at).present?;  end

  def published_at
    ## todo/fix: use a new name - do NOT squeeze convenience lookup into existing
    #    db backed attribute

    read_attribute_w_fallbacks(
      :published_at,
      :touched_at      # try touched_at (aka updated)
    )
  end

end  # class Item


  end # module Models
end # module Pluto
