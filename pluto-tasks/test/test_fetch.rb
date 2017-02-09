# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_fetch.rb
#  or better
#     rake test

require 'helper'


class TestFetch < MiniTest::Test

  def test_ruby
    Pluto.setup_planet( 'ruby' )

    assert true    ## if we get here it should work
  end

end # class TestFetch
