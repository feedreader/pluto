# pluto-news gem - newsreader for easy (re)use - build your own facebook newsfeed in 5 minutes
  

* home  :: [github.com/feedreader/pluto](https://github.com/feedreader/pluto)
* bugs  :: [github.com/feedreader/pluto/issues](https://github.com/feedreader/pluto/issues)
* gem   :: [rubygems.org/gems/pluto-news](https://rubygems.org/gems/pluto-news)
* rdoc  :: [rubydoc.info/gems/pluto-news](http://rubydoc.info/gems/pluto-news)
* forum :: [groups.google.com/group/wwwmake](http://groups.google.com/group/wwwmake)



## Usage

The `News` module offers easy to (re)use "porcelain" helpers / methods
that hide the "plumbing" for building your own newsreader or newsfeeds in minutes.


### Step 1 - Subscribe

Use the `News.subscribe( *feeds )` method to subscribe to news feeds / channels.
Example:

```ruby
News.subscribe(
  'http://www.ruby-lang.org/en/feeds/news.rss',     # Ruby Lang News
  'http://www.jruby.org/atom.xml',                  # JRuby Lang News
  'http://blog.rubygems.org/atom.xml',              # RubyGems News
  'http://bundler.io/blog/feed.xml',                # Bundler News
  'http://weblog.rubyonrails.org/feed/atom.xml',    # Ruby on Rails News
  'http://sinatrarb.com/feed.xml',                  # Sinatra News
  'https://hanamirb.org/atom.xml',                  # Hanami News
  'http://jekyllrb.com/feed.xml',                   # Jekyll News
  'http://feeds.feedburner.com/jetbrains_rubymine?format=xml',  # RubyMine IDE News
  'https://blog.phusion.nl/rss/',                   # Phusion News
  'https://rubyinstaller.org/feed.xml',             # Ruby Installer for Windows News
  'http://planetruby.github.io/calendar/feed.xml',  # Ruby Conferences & Camps News
  'https://rubytogether.org/news.xml',              # Ruby Together News
  'https://foundation.travis-ci.org/feed.xml',      # Travis Foundation News
  'https://railsgirlssummerofcode.org/blog.xml',    # Rails Girls Summer of Code News

  'http://blog.zenspider.com/atom.xml',          # Ryan Davis @ Seattle › Washington › United States
  'http://tenderlovemaking.com/atom.xml',        # Aaron Patterson @ Seattle › Washington › United States
  'http://blog.headius.com/feed.xml',            # Charles Nutter @ Richfield › Minnesota › United States
  'http://www.schneems.com/feed.xml',            # Richard Schneeman @ Austin › Texas › United States
  'https://eregon.me/blog/feed.xml',             # Benoit Daloze @ Zurich › Switzerland
  'http://samsaffron.com/posts.rss',             # Sam Saffron @ Sydney › Australia
  )
```


Note: If you call `News.subscribe` the method will setup a single-file SQLite database,
that is, `./news.db` and auto-migrate the schema, that is, database tables and so on.


### Step 2 - Update

Use the `News.update` method to fetch from the internets all news feeds / channels
and update the `./news.db` database.

Example:

```ruby
News.update
```



### Step 3 - Query and Remix the News Items

Profit!  Now you can query the `./news.db` database with any of the many
pre-made / ready-to-use query helpers.

Example:

``` ruby
puts ":::::::::::::::::::::::::::::::::::::::::::::::::::"
puts ":: #{News.items.count} news items from #{News.channels.count} channels:"
puts
```

resulting in:

```
:::::::::::::::::::::::::::::::::::::::::::::::::::
:: 793 news items from 21 channels:
```

and

``` ruby
puts "100 Latest News Items"
News.latest.limit( 100 ).each do |item|
  print "%4dd " % (Date.today.jd-item.updated.to_date.jd)
  print "  #{item.updated}"
  print " - #{item.title}"
  print " - #{URI(item.feed.feed_url).host}"
  print "\n"
end
```

resulting in:

```
100 Latest News Items
   0d   2020-02-04 00:00:00 - RubyNess @ Inverness, Scotland, United Kingdom - Ruby Conferences 'n' Camps Update - planetruby.github.io
   0d   2020-02-04 00:00:00 - Ruby by the Bay (Ruby for Good, West Coast Edition) @ Marin Headlands (near San Francisco), California, United States - Ruby Conferences 'n' Camps Update - planetruby.github.io
   8d   2020-01-27 14:44:38 - RubyMine 2020.1 EAP is Open!  - jetbrains.com
  11d   2020-01-24 00:00:00 - Crowdfunding for 2020 scholarships has commenced - railsgirlssummerofcode.org
  15d   2020-01-20 00:00:00 - Alumni Interview with Keziah Naggita - railsgirlssummerofcode.org
  16d   2020-01-19 00:00:00 - This week in Rails - Rack 2.1 released, disallowed deprecations, and more! - weblog.rubyonrails.org
  19d   2020-01-16 00:00:00 - Rails Camp West @ Diablo Lake, Washington, United States - Ruby Conferences 'n' Camps Update - planetruby.github.io
  19d   2020-01-16 00:00:00 - RubyConf Belarus (BY) @ Minsk, Belarus - Ruby Conferences 'n' Camps Update - planetruby.github.io
  22d   2020-01-13 14:00:39 - Guide to String Encoding in Ruby - tenderlovemaking.com
  23d   2020-01-12 23:00:00 - A Migration Path to Bundler 2+ - eregon.me
  24d   2020-01-11 00:00:00 - This week in Rails - Deprecations, bugfixes and improvements! - weblog.rubyonrails.org
  30d   2020-01-05 00:00:00 - This week in Rails - The 2019 edition - weblog.rubyonrails.org
  30d   2020-01-05 00:00:00 - RubyInstaller 2.7.0-1 released - rubyinstaller.org
  32d   2020-01-03 00:00:00 - Submit Your Open Source Projects - railsgirlssummerofcode.org
  34d   2020-01-01 00:00:00 - Happy new year & Sinatra 2.0.8! - sinatrarb.com
  39d   2019-12-27 00:00:00 - Ruby 2.7.0, Rails 6.0.2.1 and more - weblog.rubyonrails.org
  41d   2019-12-25 00:00:00 - Ruby 2.7.0 Released - ruby-lang.org
  ...
```

More queries include:

``` ruby
News.today

News.week
News.week( 1 )
News.week( 1, 2019 )

News.month
News.month( 1 )
News.month( 1, 2019 )

News.year
News.year( 2019 )

News.this_week
News.this_month
News.this_year

News.q1
News.q2
News.q3
News.q4
```

and some more.



### All Together Now - Let's Build A Newsfeed in 20 Lines

```ruby
require 'pluto/news'

# step 1) subscribe to a list of news feeds / channels

News.subscribe(
  'http://www.ruby-lang.org/en/feeds/news.rss',     # Ruby Lang News
  'http://www.jruby.org/atom.xml',                  # JRuby Lang News
  'http://blog.rubygems.org/atom.xml',              # RubyGems News
  'http://bundler.io/blog/feed.xml',                # Bundler News
  'http://weblog.rubyonrails.org/feed/atom.xml',    # Ruby on Rails News
  'http://sinatrarb.com/feed.xml',                  # Sinatra News
  'https://hanamirb.org/atom.xml',                  # Hanami News
  'http://jekyllrb.com/feed.xml',                   # Jekyll News
  'http://feeds.feedburner.com/jetbrains_rubymine?format=xml',  # RubyMine IDE News
  'https://blog.phusion.nl/rss/',                   # Phusion News
  'https://rubyinstaller.org/feed.xml',             # Ruby Installer for Windows News
  'http://planetruby.github.io/calendar/feed.xml',  # Ruby Conferences & Camps News
  'https://rubytogether.org/news.xml',              # Ruby Together News
  'https://foundation.travis-ci.org/feed.xml',      # Travis Foundation News
  'https://railsgirlssummerofcode.org/blog.xml',    # Rails Girls Summer of Code News

  'http://blog.zenspider.com/atom.xml',          # Ryan Davis @ Seattle › Washington › United States
  'http://tenderlovemaking.com/atom.xml',        # Aaron Patterson @ Seattle › Washington › United States
  'http://blog.headius.com/feed.xml',            # Charles Nutter @ Richfield › Minnesota › United States
  'http://www.schneems.com/feed.xml',            # Richard Schneeman @ Austin › Texas › United States
  'https://eregon.me/blog/feed.xml',             # Benoit Daloze @ Zurich › Switzerland
  'http://samsaffron.com/posts.rss',             # Sam Saffron @ Sydney › Australia
  )


# step 2) fetch and update news feeds / channels

News.update


# step 3) mix up all postings in a new page

NEWSFEED_TEMPLATE = <<TXT
<% News.latest.limit(100).each do |item| %>
  <div class="item">
    <h2><a href="<%= item.url %>"><%= item.title %></a></h2>
    <div><%= item.content %></div>
  </div>
<% end %>
TXT

puts ERB.new( NEWSFEED_TEMPLATE ).result
```



## License

![](https://publicdomainworks.github.io/buttons/zero88x31.png)

The `pluto-news` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.

## Questions? Comments?

Send them along to the [wwwmake Forum/Mailing List](http://groups.google.com/group/wwwmake).
Thanks!
