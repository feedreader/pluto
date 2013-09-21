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
    order( 'coalesce(published_at,touched_at,built_at,fetched_at) desc' )
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
      read_attribute(:touched_at)
    elsif read_attribute(:built_at).present?
      read_attribute(:built_at)
    else
      read_attribute(:fetched_at)
    end
  end

end  # class Feed

class Item < ActiveRecord::Base
  self.table_name = 'items'

  belongs_to :feed
  
  def self.latest
    # note: order by first non-null datetime field
    #   coalesce - supported by sqlite (yes), postgres (yes)
    order( 'coalesce(published_at,touched_at,fetched_at) desc' )
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
      read_attribute(:touched_at)
    else
      read_attribute(:fetched_at)
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
