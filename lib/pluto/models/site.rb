module Pluto
  module Models

class Site < ActiveRecord::Base
  self.table_name = 'sites'
  
  has_many :subscriptions
  has_many :feeds, :through => :subscriptions
  has_many :items, :through => :feeds

  ##################################
  # attribute reader aliases
  def name()        title;    end  # alias for title

end

  end # module Models
end # module Pluto
