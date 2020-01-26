#  pluto-update gem - planet feed 'n' subscription updater

* home  :: [github.com/feedreader/pluto](https://github.com/feedreader/pluto)
* bugs  :: [github.com/feedreader/pluto/issues](https://github.com/feedreader/pluto/issues)
* gem   :: [rubygems.org/gems/pluto-update](https://rubygems.org/gems/pluto-update)
* rdoc  :: [rubydoc.info/gems/pluto-update](http://rubydoc.info/gems/pluto-update)
* forum :: [groups.google.com/group/wwwmake](http://groups.google.com/group/wwwmake)



## Usage

### Planet Configuration Sample

`ruby.ini`:

```
title = Planet Ruby

[rubylang]
  title = Ruby Lang News
  link  = http://www.ruby-lang.org/en/news
  feed  = http://www.ruby-lang.org/en/feeds/news.rss

[rubyonrails]
  title = Ruby on Rails Blog
  link  = http://weblog.rubyonrails.org
  feed  = http://weblog.rubyonrails.org/feed/atom.xml
```

For more samples, see [`nytimes.ini`](https://github.com/feedreader/planets/blob/master/nytimes.ini),
[`js.ini`](https://github.com/feedreader/planet-web/blob/master/js.ini),
[`dart.ini`](https://github.com/feedreader/planet-web/blob/master/dart.ini),
[`haskell.ini`](https://github.com/feedreader/planets/blob/master/haskell.ini).



### Shortcuts / Helpers

#### Meetup

```
meetup = parisrb
```

gets auto-completed to

```
link = http://www.meetup.com/parisrb
feed = http://www.meetup.com/parisrb/events/rss/parisrb/
```

#### Google Groups

```
googlegroups = beerdb
```

gets auto-completed to

```
link = https://groups.google.com/group/beerdb
feed = https://groups.google.com/forum/feed/beerdb/topics/atom.xml?num=15
```

#### GitHub Project

```
github = jekyll/jekyll
```

gets auto-completed to

```
link = https://github.com/jekyll/jekyll
feed = https://github.com/jekyll/jekyll/commits/master.atom
```

#### Rubygems

```
rubygems = jekyll
```

gets auto-completed to

```
link = http://rubygems.org/gems/jekyll
feed = http://rubygems.org/gems/jekyll/versions.atom
```



## License

![](https://publicdomainworks.github.io/buttons/zero88x31.png)

The `pluto-update` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.

## Questions? Comments?

Send them along to the [wwwmake Forum/Mailing List](http://groups.google.com/group/wwwmake).
Thanks!
