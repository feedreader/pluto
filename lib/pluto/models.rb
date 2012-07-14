module Pluto

class Feed < ActiveRecord::Base
  self.table_name = 'feeds'
  
  has_many :items
end

class Item < ActiveRecord::Base
  self.table_name = 'items'

  belongs_to :feed
  # has_many :comments  # add??
end

end # module Pluto
