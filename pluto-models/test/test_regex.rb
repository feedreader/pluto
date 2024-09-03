###
#  to run use
#     ruby -I ./lib -I ./test test/test_regex.rb


require 'helper'

class TestRegex < Minitest::Test

  FIX_DATE_SLUG_RE = Pluto::Model::Feed::FIX_DATE_SLUG_RE

  def test_fix_dates
    m = FIX_DATE_SLUG_RE.match( ' /news/2019-10-17-growing-ruby-together' )
    assert_equal false,   m.nil?
    assert_equal '2019', m[:year]
    assert_equal '10',   m[:month]
    assert_equal '17',   m[:day]

    ## check \b (boundray)  
    m = FIX_DATE_SLUG_RE.match( ' /news/002019-10-1700-growing-ruby-together' )
    assert_equal true,   m.nil?
    m = FIX_DATE_SLUG_RE.match( ' /news/2019-10-1700-growing-ruby-together' )
    assert_equal true,   m.nil?
    m = FIX_DATE_SLUG_RE.match( ' /news/xxx2019-10-1700-growing-ruby-together' )
    assert_equal true,   m.nil?
  end

end # class TestRegex
