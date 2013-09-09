# pluto

Another Planet Generator in Ruby - Lets You Build Web Pages
from Published Web Feeds

* home  :: [github.com/geraldb/pluto](https://github.com/geraldb/pluto)
* bugs  :: [github.com/geraldb/pluto/issues](https://github.com/geraldb/pluto/issues)
* gem   :: [rubygems.org/gems/pluto](https://rubygems.org/gems/pluto)
* rdoc  :: [rubydoc.info/gems/pluto](http://rubydoc.info/gems/pluto)


## Usage

Use the `pluto` command line tool and pass in one or more planet configuration files.
Example:

    pluto ruby.yml

This will

1) fetch all feeds listed in `ruby.yml` and 

2) store all entries in a local database, that is, `ruby.sqlite` in your working folder and

3) generate a planet web page, that is, `ruby.html` using the builtin [`blank` template](https://github.com/geraldb/pluto/blob/master/templates/blank.html.erb) in your working folder using all feed entries from the local database.

Open up `ruby.html` to see your planet web page. Voila!


### Command Line

~~~
pluto - Lets you build web pages from published web feeds.

Usage: pluto [options]
    -t, --template MANIFEST          Generate Templates
    -c, --config PATH                Configuration Path (default is ~/.pluto)
    -o, --output PATH                Output Path (default is .)
    -v, --version                    Show version
        --verbose                    Show debug trace
    -h, --help                       Show this message
~~~


### Planet Configuration Sample 

`ruby.yml`:

```
title: Planet Ruby

feeds:
  - rubyflow
  - rubysource
  - edgerails
  - rubyonrails
  - railstutorial

rubyflow:
  title: Ruby Flow
  feed_url: http://feeds.feedburner.com/Rubyflow?format=xml
  url: http://rubyflow.com

rubysource:
  title: Ruby Source
  feed_url: http://rubysource.com/feed
  url: http://rubysource.com

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


## Alternatives

planet.rb by Akira Yamada [(Site)](http://planet.rubyforge.org)

Planet.rb by Pablo Astigarraga [(Site)](https://github.com/pote/planet.rb)  - Used with Jekyll/Octopress Site Generator


## License

The `pluto` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.
