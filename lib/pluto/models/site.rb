# encoding: utf-8

module Pluto
  module Model

class Site < ActiveRecord::Base
  self.table_name = 'sites'
  
  has_many :subscriptions
  has_many :feeds, :through => :subscriptions
  has_many :items, :through => :feeds

  ##################################
  # attribute reader aliases
  def name()        title;    end  # alias for title
  def fetched_at()  fetched;  end  # - legacy attrib reader -- remove!!!

  def owner_name()  author;  end  # alias    for author
  def owner()       author;  end  # alias(2) for author
  def author_name() author;  end  # alias(3) for author

  def owner_email()  email;  end  # alias    for email
  def author_email() email;  end  # alias(2) for email

end # class Site


  end # module Model
end # module Pluto
