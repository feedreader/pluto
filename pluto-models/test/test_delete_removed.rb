###
#  to run use
#     ruby -I ./lib -I ./test test/test_delete_removed.rb


require 'helper'

class TestDeleteRemoved < Minitest::Test

  def test_delete_removed

    feed = Feed.create!(
      key: 'test',
      title: 'Feed title'
    )

    feed_data = FeedParser::Feed.new
    feed_data.title = 'Feed data title'
    feed_data.items = []

    item_data = FeedParser::Item.new
    item_data.guid = 'https://myblog.com/?p=1113'
    item_data.title = 'Good post #3'
    item_data.published = Time.now
    feed_data.items << item_data

    item_data = FeedParser::Item.new
    item_data.guid = 'https://myblog.com/?p=1112'
    item_data.title = 'Spam post #2'
    item_data.published = Time.now - 10.minutes
    feed_data.items << item_data

    item_data = FeedParser::Item.new
    item_data.guid = 'https://myblog.com/?p=1111'
    item_data.title = 'Good post #1'
    item_data.published = Time.now - 20.minutes

    feed_data.items << item_data

    feed.deep_update_from_struct!( feed_data )

    assert_equal(3, Item.count)


    feed_data.items = []

    item_data = FeedParser::Item.new
    item_data.guid = 'https://myblog.com/?p=1113'
    item_data.title = 'Good post #2'
    item_data.published = Time.now
    feed_data.items << item_data

    item_data = FeedParser::Item.new
    item_data.guid = 'https://myblog.com/?p=1111'
    item_data.title = 'Good post #1'
    item_data.published = Time.now - 20.minutes
    feed_data.items << item_data

    feed.deep_update_from_struct!( feed_data )

    assert_equal(2, Item.count)
  end
end # class TestDeleteRemoved
