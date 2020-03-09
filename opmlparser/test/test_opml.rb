###
#  to run use
#     ruby -I ./lib -I ./test test/test_opml.rb


require 'helper'


class TestOpml < MiniTest::Test

  def test_samples_opml
    h = OPML.load_file( './test/outlines/category.opml.xml' )
    h = OPML.load_file( './test/outlines/places_lived.opml.xml' )
    h = OPML.load_file( './test/outlines/states.opml.xml' )

    assert_equal "United States", h['outline'][0]['text']
    assert_equal "Far West",      h['outline'][0]['outline'][0]['text']
    assert_equal "Alaska",        h['outline'][0]['outline'][0]['outline'][0]['text']
    assert_equal "Great Plains",  h['outline'][0]['outline'][1]['text'] 
  end

  def test_samples_outline
    o = Outline.read( './test/outlines/category.opml.xml' )
    o = Outline.read( './test/outlines/places_lived.opml.xml' )
    o = Outline.read( './test/outlines/states.opml.xml' )

    assert_equal "United States", o[0].text
    assert_equal "United States", o[0]['text']

    assert_equal "Far West",      o[0][0].text
    assert_equal "Far West",      o[0][0]['text']

    assert_equal "Alaska",        o[0][0][0].text
    assert_equal "Alaska",        o[0][0][0]['text']

    assert_equal "Great Plains",  o[0][1].text
    assert_equal "Great Plains",  o[0][1]['text']
    
    ## check alias_method
    o = Outline.load_file( './test/outlines/category.opml.xml' )
    o = Outline.load_file( './test/outlines/places_lived.opml.xml' )
    o = Outline.load_file( './test/outlines/states.opml.xml' )
  end
end  # class TestOpml
