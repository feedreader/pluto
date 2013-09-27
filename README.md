# pluto

Another planet generator in ruby - lets you build web pages
from published web feeds.

* home  :: [github.com/feedreader/pluto](https://github.com/feedreader/pluto)
* bugs  :: [github.com/feedreader/pluto/issues](https://github.com/feedreader/pluto/issues)
* gem   :: [rubygems.org/gems/pluto](https://rubygems.org/gems/pluto)
* rdoc  :: [rubydoc.info/gems/pluto](http://rubydoc.info/gems/pluto)


## Usage

Use the `pluto` command line tool and pass in one or more planet configuration files.
Example:

    pluto build ruby.yml        or
    pluto b ruby

This will

1) fetch all feeds listed in `ruby.yml` and 

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
    build, b    - Build planet
    install, i  - Install template pack
    list, ls, l - List installed template packs
    fetch, f    - Fetch planet feeds
    merge, m    - Merge planet template pack
    about, a    - (Debug) Show more version info
    help        - Shows a list of commands or help for one command
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
    
EXAMPLE
    pluto build ruby.yml
    pluto b ruby
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


#### `fetch` Command

~~~
NAME
    fetch - Fetch planet feeds

SYNOPSIS
    pluto [global options] fetch FILE

EXAMPLE
    pluto fetch ruby.yml
    pluto f ruby
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

EXAMPLE
    pluto merge ruby.yml
    pluto m ruby
~~~




### Planet Configuration Sample 

`ruby.ini`:

```
title = Planet Ruby

[rubyflow]
  title    = Ruby Flow
  feed_url = http://feeds.feedburner.com/Rubyflow?format=xml
  url      = http://rubyflow.com

[rubyonrails]
  title    = Ruby on Rails Blog
  feed_url = http://weblog.rubyonrails.org/feed/atom.xml
  url      = http://weblog.rubyonrails.org

[viennarb]
  title    = vienna.rb Blog
  url      = http://vienna-rb.at
  feed_url = http://vienna-rb.at/atom.xml
```

or `ruby.yml`:

```
title: Planet Ruby


rubyflow:
  title:    Ruby Flow
  feed_url: http://feeds.feedburner.com/Rubyflow?format=xml
  url:      http://rubyflow.com

rubyonrails:
  title:    Ruby on Rails Blog
  feed_url: http://weblog.rubyonrails.org/feed/atom.xml
  url:      http://weblog.rubyonrails.org

viennarb:
  title:    vienna.rb Blog
  url:      http://vienna-rb.at
  feed_url: http://vienna-rb.at/atom.xml
```

For more samples, see [`nytimes.yml`](https://github.com/feedreader/pluto.samples/blob/master/nytimes.yml),
[`js.yml`](https://github.com/feedreader/pluto.samples/blob/master/js.yml),
[`dart.yml`](https://github.com/feedreader/pluto.samples/blob/master/dart.yml).


## Install

Just install the gem:

    $ gem install pluto


## Real World Usage

[`pluto.live`](https://github.com/feedreader/pluto.live) - sample planet site; sinatra web app/starter template in ruby using the pluto gem



## Alternatives

### Ruby

`planet.rb` by Akira Yamada [(Site)](http://planet.rubyforge.org)

`planet.rb` by Pablo Astigarraga [(Site)](https://github.com/pote/planet.rb)  - used with jekyll/octopress site generator

Planet Mars by Sam Ruby [(Site](https://github.com/rubys/mars)] -  first draft of cleaned up Planet Planet code; last change in 2008

### Python

Planet Planet by Scott James Remnant n Jeff Waugh [(Site)](http://www.planetplanet.org)  - uses Mark Pilgrim's universal feed parser (RDF, RSS and Atom) and Tomas Styblo's templating engine; last release version 2.0 in 2006

Planet Venus by Sam Ruby [(Site)](https://github.com/rubys/venus) - cleaned up Planet Planet code; last change in 2010


## License

The `pluto` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.

## Questions? Comments?

Questions? Comments?
Send them along to the [Planet Pluto and Friends Forum/Mailing List](http://groups.google.com/group/feedreader).
Thanks!
