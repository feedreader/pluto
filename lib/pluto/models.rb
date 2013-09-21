module Pluto
  module Models

class Feed < ActiveRecord::Base
  self.table_name = 'feeds'

  has_many :items
  has_many :subscriptions
  has_many :sites, :through => :subscriptions


  def self.latest
    # note: order by first non-null datetime field
    #   coalesce - supported by sqlite (yes), postgres (yes)

    # note: if not published_at,touched_at or built_at use hardcoded 1999-01-01 for now
    order( "coalesce(published_at,touched_at,built_at,'1999-01-01') desc" )
  end


  def published_at?
    read_attribute(:published_at).present?
  end

  def published_at
    ## todo/fix: use a new name - do NOT squeeze convenience lookup into existing
    #    db backed attribute

    if read_attribute(:published_at).present?
      read_attribute(:published_at)
    elsif read_attribute(:touched_at).present?
      ## try touched_at (aka updated (ATOM))
      read_attribute(:touched_at)
    else  ## try build_at (aka lastBuildDate (RSS))
      read_attribute(:built_at)
    end
  end

end  # class Feed

class Item < ActiveRecord::Base
  self.table_name = 'items'

  belongs_to :feed
  
  def self.latest
    # note: order by first non-null datetime field
    #   coalesce - supported by sqlite (yes), postgres (yes)

    # note: if not published_at,touched_at or built_at use hardcoded 1999-01-01 for now
    order( "coalesce(published_at,touched_at,'1999-01-01') desc" )
  end

  def published_at?
    read_attribute(:published_at).present?
  end

  def published_at
    ## todo/fix: use a new name - do NOT squeeze convenience lookup into existing
    #    db backed attribute

    if read_attribute(:published_at).present?
      read_attribute(:published_at)
    else  ## try touched_at (aka updated)
      read_attribute(:touched_at)
    end
  end

end  # class Item


class Site < ActiveRecord::Base
  self.table_name = 'sites'
  
  has_many :subscriptions
  has_many :feeds, :through => :subscriptions
end

class Subscription < ActiveRecord::Base
  self.table_name = 'subscriptions'
  
  belongs_to :site
  belongs_to :feed
end

class Action < ActiveRecord::Base
  self.table_name = 'actions'

end


  end # module Models
end # module Pluto
