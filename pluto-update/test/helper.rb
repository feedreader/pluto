## $:.unshift(File.dirname(__FILE__))


## minitest setup
require 'minitest/autorun'

## our own code
require 'pluto/update'


Pluto.config.debug        = true
Pluto.config.logger.level = :debug


## some shortcuts
Log          = LogDb::Model::Log
Prop         = ConfDb::Model::Prop

Site         = Pluto::Model::Site
Feed         = Pluto::Model::Feed
Item         = Pluto::Model::Item
Subscription = Pluto::Model::Subscription


Pluto.setup_in_memory_db
