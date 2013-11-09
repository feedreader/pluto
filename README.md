# pluto

Another planet generator in ruby - lets you build web pages
from published web feeds.

* home  :: [github.com/feedreader/pluto](https://github.com/feedreader/pluto)
* bugs  :: [github.com/feedreader/pluto/issues](https://github.com/feedreader/pluto/issues)
* gem   :: [rubygems.org/gems/pluto](https://rubygems.org/gems/pluto)
* rdoc  :: [rubydoc.info/gems/pluto](http://rubydoc.info/gems/pluto)
* forum :: [groups.google.com/group/feedreader](http://groups.google.com/group/feedreader)

## Usage

Use the `pluto` command line tool and pass in one or more planet configuration files.
Example:

    pluto build ruby.ini        or
    pluto b ruby

This will

1) fetch all feeds listed in `ruby.ini` and 

2) store all entries in a local database, that is, `ruby.db` in your working folder and

3) generate a planet web page, that is, `ruby.html` using the [`blank` template pack](https://github.com/feedreader/pluto.blank) in your working folder using all feed entries from the local database.

Open up `ruby.html` to see your planet web page. Voila!


Note:  If you pass in no planet configuration files, the `pluto` command line tool will look
for the default planet configuration files,
that is, `pluto.ini`, `pluto.yml`, `planet.ini`, `planet.yml`.


### Command Line Tool

~~~~
NAME
    pluto - another planet generator - lets you build web pages from published web feeds

SYNOPSIS
    pluto [global options] command [command options] [arguments...]

GLOBAL OPTIONS
    -c, --config=PATH - Configuration Path (default: ~/.pluto)
    -q, --quiet       - Only show warnings, errors and fatal messages
    --verbose         - (Debug) Show debug messages
    --version         - Display the program version
    --help            - Show this message

COMMANDS
    build, b      - Build planet
    install, i    - Install template pack
    list, ls, l   - List installed template packs
    update, up, u - Update planet feeds
    merge, m      - Merge planet template pack
    about, a      - (Debug) Show more version info
    help          - Shows a list of commands or help for one command
~~~~


#### `build` Command

~~~
NAME
    build - Build planet

SYNOPSIS
    pluto [global options] build [command options] FILE

COMMAND OPTIONS
    -o, --output=PATH       - Output Path (default: .)
    -t, --template=MANIFEST - Template Manifest (default: blank)
    -d, --dbpath=PATH       - Database path (default: .)
    -n, --dbname=NAME       - Database name (default: <PLANET>.db e.g. ruby.db)

EXAMPLE
    pluto build ruby.yml
    pluto build ruby.yml --template news
    pluto b ruby
    pluto b ruby -t news
    pluto b            # will use pluto.ini|pluto.yml|planet.ini|planet.yml if present
~~~


#### `list` Command

~~~
NAME
    list - List installed template packs

SYNOPSIS
    pluto [global options] list

EXAMPLE
   pluto list
   pluto ls
~~~


#### `install` Command

~~~
NAME
    install - Install template pack

SYNOPSIS
    pluto [global options] install MANIFEST

EXAMPLE
   pluto install news      # install "river of news" template pack
~~~


#### `update` Command

~~~
NAME
    update - Update planet feeds

COMMAND OPTIONS
    -d, --dbpath=PATH       - Database path (default: .)
    -n, --dbname=NAME       - Database name (default: <PLANET>.db e.g. ruby.db)

SYNOPSIS
    pluto [global options] update FILE

EXAMPLE
    pluto update ruby.yml
    pluto u ruby
~~~


#### `merge` Command

~~~
NAME
    merge - Merge planet template pack

SYNOPSIS
    pluto [global options] merge [command options] FILE

COMMAND OPTIONS
    -o, --output=PATH       - Output Path (default: .)
    -t, --template=MANIFEST - Template Manifest (default: blank)
    -d, --dbpath=PATH       - Database path (default: .)
    -n, --dbname=NAME       - Database name (default: <PLANET>.db e.g. ruby.db)

EXAMPLE
    pluto merge ruby.yml
    pluto merge ruby.yml --template news
    pluto m ruby
    pluto m ruby -t news
~~~



### Planet Configuration Sample 

`ruby.ini`:

```
title = Planet Ruby

[rubyflow]
  title  = Ruby Flow
  link   = http://rubyflow.com
  feed   = http://feeds.feedburner.com/Rubyflow?format=xml

[rubyonrails]
  title = Ruby on Rails Blog
  link  = http://weblog.rubyonrails.org
  feed  = http://weblog.rubyonrails.org/feed/atom.xml

[viennarb]
  title = vienna.rb Blog
  link  = http://vienna-rb.at
  feed  = http://vienna-rb.at/atom.xml
```

or `ruby.yml`:

```
title: Planet Ruby


rubyflow:
  title: Ruby Flow
  link:  http://rubyflow.com
  feed:  http://feeds.feedburner.com/Rubyflow?format=xml

rubyonrails:
  title: Ruby on Rails Blog
  link:  http://weblog.rubyonrails.org
  feed:  http://weblog.rubyonrails.org/feed/atom.xml

viennarb:
  title: vienna.rb Blog
  link:  http://vienna-rb.at
  feed:  http://vienna-rb.at/atom.xml
```

For more samples, see [`nytimes.ini`](https://github.com/feedreader/pluto.samples/blob/master/nytimes.ini),
[`js.ini`](https://github.com/feedreader/pluto.samples/blob/master/js.ini),
[`dart.ini`](https://github.com/feedreader/pluto.samples/blob/master/dart.ini),
[`haskell.ini`](https://github.com/feedreader/pluto.samples/blob/master/haskell.ini),
[`viennarb.ini`](https://github.com/feedreader/pluto.samples/blob/master/viennarb.ini),
[`beer.ini`](https://github.com/feedreader/pluto.samples/blob/master/beer.ini),
[`football.ini`](https://github.com/feedreader/pluto.samples/blob/master/football.ini).


## Template Packs

- Blank - default templates; [more »](https://github.com/feedreader/pluto.blank)
- News - 'river of news' style templates; [more »](https://github.com/feedreader/pluto.news)
- Top -  Popurl-style templates; [more »](https://github.com/feedreader/pluto.top)
- Classic -  Planet Planet-Style templates; [more »](https://github.com/feedreader/pluto.classic)


## Install

Just install the gem:

    $ gem install pluto


## Real World Usage

[`pluto.live`](https://github.com/feedreader/pluto.live) - sample planet site; sinatra web app/starter template in ruby using the pluto gem



## Alternatives

### Ruby

`planet.rb` by Akira Yamada [(Site)](http://planet.rubyforge.org)

`planet.rb` by Pablo Astigarraga [(Site)](https://github.com/pote/planet.rb)  - used with jekyll/octopress site generator

Planet Mars by Sam Ruby [(Site)](https://github.com/rubys/mars) -  first draft of cleaned up Planet Planet code; last change in 2008

### Python

Planet Planet by Scott James Remnant and Jeff Waugh [(Site)](http://www.planetplanet.org)  - uses Mark Pilgrim's universal feed parser (RDF, RSS and Atom) and Tomas Styblo's templating engine; last release version 2.0 in 2006

Planet Venus by Sam Ruby [(Site)](https://github.com/rubys/venus) - cleaned up Planet Planet code; last change in 2010


## License

The `pluto` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.

## Questions? Comments?

Send them along to the [Planet Pluto and Friends Forum/Mailing List](http://groups.google.com/group/feedreader).
Thanks!
