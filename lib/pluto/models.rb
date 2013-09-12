module Pluto
  module Models
  
class Feed < ActiveRecord::Base
  self.table_name = 'feeds'
  
  has_many :items
  has_many :subscriptions
  has_many :sites, :through => :subscriptions
end

class Item < ActiveRecord::Base
  self.table_name = 'items'

  belongs_to :feed
  
  def self.latest
    order( 'published_at desc' )
  end
end

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
