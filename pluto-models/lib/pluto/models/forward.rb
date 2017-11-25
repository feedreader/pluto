# encoding: utf-8

module Pluto
  module Model

#######
# ActivityDB

# add shortcut/alias
## fix: use Model instead of Models
Activity = ActivityDb::Models::Activity

  end # module Model

  # note: convenience alias for Model
  # lets you use include Pluto::Models
  Models = Model

end # module Pluto
