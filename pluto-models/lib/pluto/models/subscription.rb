# encoding: utf-8

module Pluto
  module Model


class Subscription < ActiveRecord::Base
  self.table_name = 'subscriptions'

  belongs_to :site
  belongs_to :feed
end


  end # module Model
end # module Pluto
