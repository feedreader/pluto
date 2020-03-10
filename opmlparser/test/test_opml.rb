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

    ## check more
    o = Outline.read( './test/outlines/directory.opml.xml' )
    o = Outline.read( './test/outlines/feedbase_about.opml.xml' )
    o = Outline.read( './test/outlines/feedbase_hotlist.opml.xml' )
    o = Outline.read( './test/outlines/simple_script.opml.xml' )
    o = Outline.read( './test/outlines/subscription_list.opml.xml' )

    assert_equal "CNET News.com", o[0].text
    assert_equal "Tech news and business reports by CNET News.com. Focused on information technology, core topics include computers, hardware, software, networking, and Internet media.",
                  o[0].description
    assert_equal "http://news.com.com/", o[0].html_url 
    assert_equal "unknown",              o[0].language
    assert_equal "CNET News.com",        o[0].title
    assert_equal "rss",                  o[0].type
    assert_equal "RSS2",                 o[0].version
    assert_equal "http://news.com.com/2547-1_3-0-5.xml", o[0].xml_url
  end
end  # class TestOpml
