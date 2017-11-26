# pluto gem - command line tool

Another planet generator in ruby - lets you build web pages
from published web feeds.

* home      :: [github.com/feedreader/pluto](https://github.com/feedreader/pluto)
* bugs      :: [github.com/feedreader/pluto/issues](https://github.com/feedreader/pluto/issues)
* gem       :: [rubygems.org/gems/pluto](https://rubygems.org/gems/pluto)
* rdoc      :: [rubydoc.info/gems/pluto](http://rubydoc.info/gems/pluto)
* templates :: [github.com/planet-templates](https://github.com/planet-templates)
* forum     :: [groups.google.com/group/wwwmake](http://groups.google.com/group/wwwmake)


## Usage

```
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
```


#### `build` Command

```
NAME
    build - Build planet

SYNOPSIS
    pluto [global options] build [command options] FILE

COMMAND OPTIONS
    -o, --output=PATH       - Output Path (default: .)
    -t, --template=MANIFEST - Template Manifest (default: blank)
    -d, --dbpath=PATH       - Database path (default: .)
    -n, --dbname=NAME       - Database name (default: planet.db)

EXAMPLE
    pluto build ruby.ini
    pluto build ruby.ini --template news
    pluto b ruby.ini
    pluto b ruby.ini -t news
    pluto b            # will use planet.ini if present
```


#### `list` Command

```
NAME
    list - List installed template packs

SYNOPSIS
    pluto [global options] list

EXAMPLE
   pluto list
   pluto ls
```


#### `install` Command

```
NAME
    install - Install template pack

SYNOPSIS
    pluto [global options] install MANIFEST

EXAMPLE
   pluto install news      # install "river of news" template pack
```


#### `update` Command

```
NAME
    update - Update planet feeds

COMMAND OPTIONS
    -d, --dbpath=PATH       - Database path (default: .)
    -n, --dbname=NAME       - Database name (default: planet.db)

SYNOPSIS
    pluto [global options] update FILE

EXAMPLE
    pluto update ruby.ini
    pluto u ruby.ini
```


#### `merge` Command

```
NAME
    merge - Merge planet template pack

SYNOPSIS
    pluto [global options] merge [command options] FILE

COMMAND OPTIONS
    -o, --output=PATH       - Output Path (default: .)
    -t, --template=MANIFEST - Template Manifest (default: blank)
    -d, --dbpath=PATH       - Database path (default: .)
    -n, --dbname=NAME       - Database name (default: planet.db)

EXAMPLE
    pluto merge ruby.ini
    pluto merge ruby.ini --template news
    pluto m ruby.ini
    pluto m ruby.ini -t news
```


## Install

Just install the gem:

    $ gem install pluto


## License

![](https://publicdomainworks.github.io/buttons/zero88x31.png)

The `pluto` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.

## Questions? Comments?

Send them along to the [wwwmake Forum/Mailing List](http://groups.google.com/group/wwwmake).
Thanks!
