###
#  to run use
#     ruby -I ./lib -I ./test test/test_refresh.rb


require 'helper'

class TestRefresh < MiniTest::Test

  def setup
    Site.delete_all
    Feed.delete_all
    Item.delete_all
    Subscription.delete_all

    site_text   = File.read( "#{Pluto::Test.data_dir}/ruby.ini")
    site_config = INI.load( site_text )

    Site.deep_create_or_update_from_hash!( 'ruby', site_config )
  end


  def test_refresh_sites
    Pluto.refresh_sites

    assert true
  end

  def test_refresh_feeds
    Pluto.refresh_feeds

    assert true
  end

end # class TestRefresh
