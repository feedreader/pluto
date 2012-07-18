# pluto

Another Planet Generator in Ruby - Lets You Build Web Pages
from Published Web Feeds

* [geraldb.github.com/pluto](http://geraldb.github.com/pluto)


## Usage

Use the `pluto` command line tool and pass in one or more planet configuration files. Example:

    pluto ruby.yml


This will

1) fetch all feeds listed in `ruby.yml` and 

2) store all entries in a local database, that is, `ruby.sqlite` in your working folder and

3) generate a planet web page, that is, `ruby.html` using the builtin [`blank` template](https://github.com/geraldb/pluto/blob/master/templates/blank.html.erb) in your working folder using all feed entries from the local database.

Open up `ruby.html` to see your planet web page. Voila!


### Planet Configuration Sample 

`ruby.yml`:

```
title: Planet Ruby

feeds:
  - rubyflow
  - rubysource
  - afreshcup
  - edgerails
  - rubyonrails
  - railstutorial
  - railscasts
  - rubynews
  - railstips
  - rubymine

rubyflow:
  title: Ruby Flow
  feed_url: http://feeds.feedburner.com/Rubyflow?format=xml
  url: http://rubyflow.com

rubysource:
  title: Ruby Source
  feed_url: http://rubysource.com/feed
  url: http://rubysource.com

afreshcup:
  title: A Fresh Cup by Mike Gunderloy
  feed_url: http://afreshcup.com/home/rss.xml
  url: http://afreshcup.com

edgerails:
  title: What's new in Edge Rails?
  feed_url:  http://www.edgerails.info/blog.atom
  url: http://www.edgerails.info

rubyonrails:
  title: Ruby on Rails Blog
  feed_url: http://weblog.rubyonrails.org/feed/atom.xml
  url: http://weblog.rubyonrails.org

railstutorial:
  title: Rails Tutorial News
  feed_url: http://feeds.feedburner.com/railstutorial?format=xml
  url: http://news.railstutorial.org
```

For more samples, see [`nytimes.yml`](https://github.com/geraldb/pluto/blob/master/samples/nytimes.yml),
[`js.yml`](https://github.com/geraldb/pluto/blob/master/samples/js.yml),
[`dart.yml`](https://github.com/geraldb/pluto/blob/master/samples/dart.yml).


## Install

Just install the gem:

    $ gem install pluto


## License

The `pluto` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.