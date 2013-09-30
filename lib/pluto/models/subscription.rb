module Pluto
  module Models


class Subscription < ActiveRecord::Base
  self.table_name = 'subscriptions'
  
  belongs_to :site
  belongs_to :feed
end


  end # module Models
end # module Pluto
