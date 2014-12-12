# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_rss.rb
#  or better
#     rake test

require 'helper'

class TestHelper < MiniTest::Test

  ## add some tests; to be done

  def test_banner    
    puts Pluto.banner
    
    assert true
  end


end # class TestHelper
