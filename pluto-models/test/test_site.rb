###
#  to run use
#     ruby -I ./lib -I ./test test/test_site.rb


require 'helper'

class TestSite < Minitest::Test

  def setup
    Log.delete_all
    Site.delete_all
    Feed.delete_all
    Subscription.delete_all
    Item.delete_all
  end


  def test_site_create
    site_text   = File.read( "#{Pluto::Test.data_dir}/ruby.ini")
    site_config = INI.load( site_text )
    ## pp site_config

    assert_equal 0, Site.count
    assert_equal 0, Feed.count

    Site.deep_create_or_update_from_hash!( 'ruby', site_config )

    assert_equal 1, Site.count
    assert_equal 2, Feed.count

    ruby = Site.find_by_key!( 'ruby' )
    assert_equal 'Planet Ruby', ruby.title
    assert_equal 2, ruby.subscriptions.count
    assert_equal 2, ruby.feeds.count

    rubylang = Feed.find_by_key!( 'rubylang' )
    assert_equal 'Ruby Lang News', rubylang.title
    assert_equal 'http://www.ruby-lang.org/en/news', rubylang.url
    assert_equal 'http://www.ruby-lang.org/en/feeds/news.rss', rubylang.feed_url
  end


  def test_site_update
    site_text   = File.read( "#{Pluto::Test.data_dir}/ruby.ini")
    site_config = INI.load( site_text )
    ## pp site_config

    assert_equal 0, Site.count
    assert_equal 0, Feed.count

    ## note: call twice (first time for create, second time for update)
    Site.deep_create_or_update_from_hash!( 'ruby', site_config )
    Site.deep_create_or_update_from_hash!( 'ruby', site_config )

    assert_equal 1, Site.count
    assert_equal 2, Feed.count

    ruby = Site.find_by_key!( 'ruby' )
    assert_equal 'Planet Ruby', ruby.title
    assert_equal 2, ruby.subscriptions.count
    assert_equal 2, ruby.feeds.count

    rubylang = Feed.find_by_key!( 'rubylang' )
    assert_equal 'Ruby Lang News', rubylang.title
    assert_equal 'http://www.ruby-lang.org/en/news', rubylang.url
    assert_equal 'http://www.ruby-lang.org/en/feeds/news.rss', rubylang.feed_url
  end


end # class TestSite
