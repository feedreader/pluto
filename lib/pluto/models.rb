module Pluto

class Feed < ActiveRecord::Base
  self.table_name = 'feeds'
  
  has_many :items
end

class Item < ActiveRecord::Base
  self.table_name = 'items'

  belongs_to :feed
  
  def self.latest
    self.order( 'published_at desc' ).all
  end
end

end # module Pluto
