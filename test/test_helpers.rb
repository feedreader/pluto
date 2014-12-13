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

    assert true    ## if we get here it should workd
  end

  def test_models
    assert_equal 1, Prop.count
    assert_equal 0, Log.count

    assert_equal 0, Site.count
    assert_equal 0, Feed.count
    assert_equal 0, Item.count
    assert_equal 0, Subscription.count
  end

  def test_auto_migrate
    Pluto.auto_migrate!
    
    assert true   ## if we get here it should workd
  end

end # class TestHelper
