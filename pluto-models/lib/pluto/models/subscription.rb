# frozen_string_literal: true

module Pluto
  module Model
    class Subscription < ActiveRecord::Base
      self.table_name = 'subscriptions'

      belongs_to :site
      belongs_to :feed
    end
  end
end
