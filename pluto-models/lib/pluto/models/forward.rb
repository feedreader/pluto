# frozen_string_literal: true

module Pluto
  module Model
    #######
    # ActivityDB

    # add shortcut/alias
    ## fix: use Model instead of Models
    Activity = ActivityDb::Models::Activity
  end

  # NOTE: convenience alias for Model
  # lets you use include Pluto::Models
  Models = Model
end
