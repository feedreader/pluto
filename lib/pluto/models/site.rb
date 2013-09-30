module Pluto
  module Models

class Site < ActiveRecord::Base
  self.table_name = 'sites'
  
  has_many :subscriptions
  has_many :feeds, :through => :subscriptions
end

  end # module Models
end # module Pluto
