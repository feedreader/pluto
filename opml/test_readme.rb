require_relative './opml'


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

