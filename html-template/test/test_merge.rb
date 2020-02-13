###
#  to run use
#     ruby -I ./lib -I ./test test/test_merge.rb

require 'helper'



class TestMerge < MiniTest::Test

  Site     = Struct.new( :name, :owner_name, :date_822, :channels )
  Channel  = Struct.new( :name, :url, :channel_link )

  def sample1
       Site.new( 'OpenStreetMap Blogs',
                 'OpenStreetMap',
                  Date.new( 2020, 2, 7 ).rfc2822,
                 [Channel.new( 'Shaun McDonald',
                               'http://blog.shaunmcdonald.me.uk/feed/',
                               'http://blog.shaunmcdonald.me.uk/' ),
                  Channel.new( 'Mapbox',
                               'https://blog.mapbox.com/feed/tagged/openstreetmap/',
                               'https://blog.mapbox.com/' ),
                  Channel.new( 'Mapillary',
                               'https://blog.mapillary.com/rss.xml',
                               'https://blog.mapillary.com' ),
                  Channel.new( 'Richard Fairhurst',
                               'http://blog.systemed.net/rss',
                               'http://blog.systemed.net/' )]
                )
  end

  def test_merge
     site = sample1
     pp site

     xml      = File.open( "#{HtmlTemplate.root}/test/templates/opml.xml",      "r:utf-8" ).read
     template = File.open( "#{HtmlTemplate.root}/test/templates/opml.xml.tmpl", "r:utf-8" ).read

     t = HtmlTemplate.new( template )

     assert_equal prettify_xml( xml ),
                  prettify_xml( t.render( name:       site.name,
                                          owner_name: site.owner_name,
                                          date_822:   site.date_822,
                                          channels:   site.channels ))
  end


  def test_convert
    text     = File.open( "#{HtmlTemplate.root}/test/templates/opml.xml.erb", "r:utf-8" ).read
    template = File.open( "#{HtmlTemplate.root}/test/templates/opml.xml.tmpl", "r:utf-8" ).read

    t = HtmlTemplate.new( template )

    assert_equal text, t.text
  end

=begin
<!-- students.tmpl -->
<TMPL_LOOP NAME=STUDENT>
   <p>
   Name: <TMPL_VAR NAME=NAME><br/>
   GPA: <TMPL_VAR NAME=GPA>
   </p>
</TMPL_LOOP>

# students.pl
my $template = HTML::Template->new(filename => 'students.tmpl');

$template->param(
   STUDENT => [
      { NAME => 'Bluto Blutarsky', GPA => '0.0' },
      { NAME => 'Tracey Flick'   , GPA => '4.0' },
   ]
);
print $template->output;
=end

  def test_students_example
    t = HtmlTemplate.new( <<TXT )
<TMPL_LOOP students>
<p>
Name: <TMPL_VAR name><br/>
GPA: <TMPL_VAR gpa>
</p>
</TMPL_LOOP>
TXT

    puts t.text
    puts "---"
    result = t.render( students: [ { name: 'Bluto Blutarsky', gpa: 0.0 },
                                   { name: 'Tracey Flick',    gpa: 4.0 } ])
    puts result

    assert_equal <<TXT, result
<p>
Name: Bluto Blutarsky<br/>
GPA: 0.0
</p>
<p>
Name: Tracey Flick<br/>
GPA: 4.0
</p>
TXT
  end


  def test_escape
   t = HtmlTemplate.new( <<TXT )
<TMPL_LOOP pubs>
Name: <TMPL_VAR name>
Name: <TMPL_VAR name ESCAPE=HTML>
Name: <TMPL_VAR name ESCAPE="HTML">
Name: <TMPL_VAR name ESCAPE='HTML'>

</TMPL_LOOP>
TXT

   exp =<<TXT
Name: Fuller's Ale & Pie House
Name: Fuller&#39;s Ale &amp; Pie House
Name: Fuller&#39;s Ale &amp; Pie House
Name: Fuller&#39;s Ale &amp; Pie House

Name: Mel's Craft Beers & Diner
Name: Mel&#39;s Craft Beers &amp; Diner
Name: Mel&#39;s Craft Beers &amp; Diner
Name: Mel&#39;s Craft Beers &amp; Diner

TXT

   assert_equal exp, t.render( pubs: [{ name: "Fuller's Ale & Pie House"  },
                                      { name: "Mel's Craft Beers & Diner" }])
end

end # class TestMerge

