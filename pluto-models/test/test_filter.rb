###
#  to run use
#     ruby -I ./lib -I ./test test/test_filter.rb


require 'helper'

class TestFilter < Minitest::Test

  def test_includes

    feed1 = Feed.create!(
      key: 'test',
      title: 'Test',
      includes: 'test1,test2,github pages'
    )

    feed2 = Feed.create!(
      key: 'test',
      title: 'Test'
    )

    feed_data = FeedParser::Feed.new
    feed_data.title = 'Test'
    feed_data.items = []

    item_data = FeedParser::Item.new
    item_data.title = 'Test #1'
    item_data.summary = 'Test'
    item_data.content = 'Test'
    item_data.updated = Date.today

    feed_data.items << item_data

    item_data = FeedParser::Item.new
    item_data.title = 'Test #2'
    item_data.summary = "Test\nTest\nTest1"
    item_data.content = 'Test'
    item_data.updated = Date.today

    feed_data.items << item_data


    item_data = FeedParser::Item.new
    item_data.title = 'Test #3'
    item_data.summary = "Test\nTest\nTest"
    item_data.content = 'Test\nTest\nGitHub Pages'
    item_data.updated = Date.today

    feed_data.items << item_data

    feed1.deep_update_from_struct!( feed_data )   ## check w/ includes
    feed2.deep_update_from_struct!( feed_data )   ## check w/o includes

    assert true    ## if we get here it should workd
  end

end # class TestFilter
