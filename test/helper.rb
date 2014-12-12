## $:.unshift(File.dirname(__FILE__))


## minitest setup

require 'minitest/autorun'

## our own code
require 'pluto-models'


LogUtils::Logger.root.level = :debug

