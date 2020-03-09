# opmlparser gem - read / parse outlines (incl. feed subscription lists) in the OPML (Outline Processor Markup Language) format in xml


* home  :: [github.com/feedreader/pluto](https://github.com/feedreader/pluto)
* bugs  :: [github.com/feedreader/pluto/issues](https://github.com/feedreader/pluto/issues)
* gem   :: [rubygems.org/gems/opmlparser](https://rubygems.org/gems/opmlparser)
* rdoc  :: [rubydoc.info/gems/opmlparser](http://rubydoc.info/gems/opmlparser)
* forum :: [groups.google.com/group/wwwmake](http://groups.google.com/group/wwwmake)


## Usage

`OPML.load` • `OPML.load_file`


Option 1) `OPML.load` - load from string. Example:

``` ruby
hash = OPML.load( <<TXT )
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
```


Option 2) `OPML.load_file` - load from file (shortcut). Example:

``` ruby
hash = OPML.load_file( './planet.opml.xml' )
```


All together now. Example:

``` ruby
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
```

resulting in:

``` ruby
{"meta"=>
  {"title"=>"Planet Ruby",
   "dateCreated"=>"Mon, 02 Mar 2020 08:21:56 -0000"},
 "outline"=>
  [{"text"=>"Ruby Lang News", "xmlUrl"=>"http://www.ruby-lang.org/en/feeds/news.rss"},
   {"text"=>"JRuby Lang News", "xmlUrl"=>"http://www.jruby.org/atom.xml"},
   {"text"=>"RubyGems News", "xmlUrl"=>"http://blog.rubygems.org/atom.xml"},
   {"text"=>"Sinatra News", "xmlUrl"=>"http://sinatrarb.com/feed.xml"},
   {"text"=>"Hanami News", "xmlUrl"=>"https://hanamirb.org/atom.xml"},
   {"text"=>"Jekyll News", "xmlUrl"=>"http://jekyllrb.com/feed.xml"}]}
```

to access use:

``` ruby
hash['meta']['title']         #=> "Planet Ruby"
hash['outline'][0]['text']    #=> "Ruby Lang News"
hash['outline'][0]['xmlUrl']  #=> "http://www.ruby-lang.org/en/feeds/news.rss"
hash['outline'][1]['text']    #=> "JRuby Lang News"
hash['outline'][1]['xmlUrl']  #=> "http://www.jruby.org/atom.xml"
```


What about using a "type-safe" outline struct(ure)?

`Outline.parse` • `Outline.read`

Option 1) `Outline.parse` - parse from string. Example:

``` ruby
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
```

Option 2) `Outline.read` - read from file (shortcut). Example:

``` ruby
outline = Outline.read( './planet.opml.xml' )
```

to access use:

``` ruby
outline.meta.title    #=> "Planet Ruby"
outline[0].text       #=> "Ruby Lang News"
outline[0].xml_url    #=> "http://www.ruby-lang.org/en/feeds/news.rss"
outline[1].text       #=> "JRuby Lang News"
outline[1].xml_url    #=> "http://www.jruby.org/atom.xml"
```


What about "non-flat" nested tree outlines?

Example - `states.opml.xml`:

``` xml
<opml version="2.0">
  <head>
    <title>states.opml</title>
    <dateCreated>Tue, 15 Mar 2005 16:35:45 GMT</dateCreated>
    <dateModified>Thu, 14 Jul 2005 23:41:05 GMT</dateModified>
    <ownerName>Dave Winer</ownerName>
    <ownerEmail>dave@scripting.com</ownerEmail>
  </head>
  <body>
    <outline text="United States">
      <outline text="Far West">
        <outline text="Alaska"/>
        <outline text="California"/>
        <outline text="Hawaii"/>
        <outline text="Nevada">
          <outline text="Reno" created="Tue, 12 Jul 2005 23:56:35 GMT"/>
          <outline text="Las Vegas" created="Tue, 12 Jul 2005 23:56:37 GMT"/>
          <outline text="Ely" created="Tue, 12 Jul 2005 23:56:39 GMT"/>
          <outline text="Gerlach" created="Tue, 12 Jul 2005 23:56:47 GMT"/>
          </outline>
        <outline text="Oregon"/>
        <outline text="Washington"/>
        </outline>
      <outline text="Great Plains">
        <outline text="Kansas"/>
        <outline text="Nebraska"/>
        <outline text="North Dakota"/>
        <outline text="Oklahoma"/>
        <outline text="South Dakota"/>
        </outline>
      <outline text="Mid-Atlantic">
        <outline text="Delaware"/>
        <outline text="Maryland"/>
        <outline text="New Jersey"/>
        <outline text="New York"/>
        <outline text="Pennsylvania"/>
        </outline>
      <outline text="Midwest">
        <outline text="Illinois"/>
        <outline text="Indiana"/>
        <outline text="Iowa"/>
        <outline text="Kentucky"/>
        <outline text="Michigan"/>
        <outline text="Minnesota"/>
        <outline text="Missouri"/>
        <outline text="Ohio"/>
        <outline text="West Virginia"/>
        <outline text="Wisconsin"/>
        </outline>
      <outline text="Mountains">
        <outline text="Colorado"/>
        <outline text="Idaho"/>
        <outline text="Montana"/>
        <outline text="Utah"/>
        <outline text="Wyoming"/>
        </outline>
      <outline text="New England">
        <outline text="Connecticut"/>
        <outline text="Maine"/>
        <outline text="Massachusetts"/>
        <outline text="New Hampshire"/>
        <outline text="Rhode Island"/>
        <outline text="Vermont"/>
        </outline>
      <outline text="South">
        <outline text="Alabama"/>
        <outline text="Arkansas"/>
        <outline text="Florida"/>
        <outline text="Georgia"/>
        <outline text="Louisiana"/>
        <outline text="Mississippi"/>
        <outline text="North Carolina"/>
        <outline text="South Carolina"/>
        <outline text="Tennessee"/>
        <outline text="Virginia"/>
        </outline>
      <outline text="Southwest">
        <outline text="Arizona"/>
        <outline text="New Mexico"/>
        <outline text="Texas"/>
        </outline>
      </outline>
    </body>
  </opml>
```

Yes, use `OPML.load` / `load_file`. To access use:

``` ruby
hash['outline'][0]['text']                              #=> "United States"
hash['outline'][0]['outline'][0]['text']                #=> "Far West"
hash['outline'][0]['outline'][0]['outline'][0]['text']  #=> "Alaska"
hash['outline'][0]['outline'][1]['text']                #=> "Great Plains"
```

Or use `Outline.parse` / `read`. To access use:

``` ruby
outline[0].text        #=> "United States"
outline[0][0].text     #=> "Far West"
outline[0][0][0].text  #=> "Alaska"
outline[0][1].text     #=> "Great Plains"
```

That's all for now.


## License

The `opmlparser` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.

## Questions? Comments?

Send them along to the [wwwmake Forum/Mailing List](http://groups.google.com/group/wwwmake).
Thanks!
