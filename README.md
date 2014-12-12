# pluto-models gem - planet models and generator machinery for easy (re)use

* home  :: [github.com/feedreader/pluto-models](https://github.com/feedreader/pluto-models)
* bugs  :: [github.com/feedreader/pluto-models/issues](https://github.com/feedreader/pluto-models/issues)
* gem   :: [rubygems.org/gems/pluto-models](https://rubygems.org/gems/pluto-models)
* rdoc  :: [rubydoc.info/gems/pluto-models](http://rubydoc.info/gems/pluto-models)
* forum :: [groups.google.com/group/feedreader](http://groups.google.com/group/feedreader)



## Usage

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


## Real World Usage

[`pluto`](https://github.com/feedreader/pluto) - planet generator command line tool using the pluto-models gem
[`pluto.live`](https://github.com/feedreader/pluto.live) - sample planet site; sinatra web app/starter template in ruby using the pluto-models gem



## License

The `pluto-models` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.

## Questions? Comments?

Send them along to the [Planet Pluto and Friends Forum/Mailing List](http://groups.google.com/group/feedreader).
Thanks!
