###
#  to run use
#     ruby -I ./lib -I ./test test/test_helpers.rb


require 'helper'

class TestHelper < Minitest::Test

  def setup
    Log.delete_all
    Site.delete_all
    Feed.delete_all
    Subscription.delete_all
    Item.delete_all
  end

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


   include TextUtils::HypertextHelper   ## e.g. lets us use strip_tags( ht )

  def test_feed_title2_sanitize
##
# todo:
##  strip all tags from title2
##  limit to 255 chars
## e.g. title2 such as this exist

    title2_in  = %Q{This is a low-traffic announce-only list for people interested in hearing news about Polymer (<a href="http://polymer-project.org">http://polymer-project.org</a>). The higher-traffic mailing list for all kinds of discussion is <a href="https://groups.google.com/group/polymer-dev">https://groups.google.com/group/polymer-dev</a>}
    title2_out = %Q{This is a low-traffic announce-only list for people interested in hearing news about Polymer (http://polymer-project.org). The higher-traffic mailing list for all kinds of discussion is https://groups.google.com/group/polymer-dev}

    assert_equal title2_out, strip_tags( title2_in )
    assert_equal 229, strip_tags( title2_in )[0...255].length
  end

end # class TestHelper
