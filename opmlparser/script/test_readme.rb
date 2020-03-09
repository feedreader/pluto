###
#  to run use
#     ruby -I ./lib script/test_readme.rb


require 'opmlparser'



xml = <<TXT
  <opml version="1.1">
    <head>
      <title>Planet Ruby</title>
      <dateCreated>Mon, 02 Mar 2020 08:21:56 -0000</dateCreated>
    </head>
    <body>
      <outline text="Ruby Lang News" xmlUrl="http://www.ruby-lang.org/en/feeds/news.rss"/>
      <outline text="JRuby Lang News" xmlUrl="http://www.jruby.org/atom.xml"/>
      <outline text="RubyGems News" xmlUrl="http://blog.rubygems.org/atom.xml"/>
      <outline text="Sinatra News" xmlUrl="http://sinatrarb.com/feed.xml"/>
      <outline text="Hanami News" xmlUrl="https://hanamirb.org/atom.xml"/>
      <outline text="Jekyll News" xmlUrl="http://jekyllrb.com/feed.xml"/>
    </body>
  </opml>
TXT

hash = OPML.load( xml )
pp hash

p hash['meta']['title']         #=> "Planet Ruby"
p hash['outline'][0]['text']    #=> "Ruby Lang News"
p hash['outline'][0]['xmlUrl']  #=> "http://www.ruby-lang.org/en/feeds/news.rss"
p hash['outline'][1]['text']    #=> "JRuby Lang News"
p hash['outline'][1]['xmlUrl']  #=> "http://www.jruby.org/atom.xml"


outline = Outline.parse( <<TXT )
  <opml version="1.1">
    <head>
      <title>Planet Ruby</title>
      <dateCreated>Mon, 02 Mar 2020 08:21:56 -0000</dateCreated>
    </head>
    <body>
      <outline text="Ruby Lang News" xmlUrl="http://www.ruby-lang.org/en/feeds/news.rss"/>
      <outline text="JRuby Lang News" xmlUrl="http://www.jruby.org/atom.xml"/>
      <outline text="RubyGems News" xmlUrl="http://blog.rubygems.org/atom.xml"/>
      <outline text="Sinatra News" xmlUrl="http://sinatrarb.com/feed.xml"/>
      <outline text="Hanami News" xmlUrl="https://hanamirb.org/atom.xml"/>
      <outline text="Jekyll News" xmlUrl="http://jekyllrb.com/feed.xml"/>
    </body>
  </opml>
TXT

pp outline

p outline.meta.title    #=> "Planet Ruby"
p outline[0].text       #=> "Ruby Lang News"
p outline[0].xml_url    #=> "http://www.ruby-lang.org/en/feeds/news.rss"
p outline[1].text       #=> "JRuby Lang News"
p outline[1].xml_url    #=> "http://www.jruby.org/atom.xml"



hash = OPML.load_file( './test/outlines/states.opml.xml' )

p hash['outline'][0]['text']                              #=> "United States"
p hash['outline'][0]['outline'][0]['text']                #=> "Far West"
p hash['outline'][0]['outline'][0]['outline'][0]['text']  #=> "Alaska"
p hash['outline'][0]['outline'][1]['text']                #=> "Great Plains"


outline = Outline.read( './test/outlines/states.opml.xml' )

p outline[0].text        #=> "United States"
p outline[0][0].text     #=> "Far West"
p outline[0][0][0].text  #=> "Alaska"
p outline[0][1].text     #=> "Great Plains"
