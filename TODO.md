# TODOS - Notes, Ideas


## Net::HTTP

fix warning - what is the ne alternative?

```


feedreader/pluto/pluto-update/lib/pluto/update/site_fetcher.rb:92:in `fetch': warning: Net::HTTPResponse#header is obsolete
http header - server:  - NilClass
feedreader/pluto/pluto-update/lib/pluto/update/site_fetcher.rb:93:in `fetch': warning: Net::HTTPResponse#header is obsolete
feedreader/pluto/pluto-update/lib/pluto/update/site_fetcher.rb:93:in `fetch': warning: Net::HTTPResponse#header is obsolete
http header - etag: W/"91f95d63232681e956fc58ac351bc459a8b1048196d242220202d42b54298264" - String
feedreader/pluto/pluto-update/lib/pluto/update/site_fetcher.rb:94:in `fetch': warning: Net::HTTPResponse#header is obsolete
feedreader/pluto/pluto-update/lib/pluto/update/site_fetcher.rb:94:in `fetch': warning: Net::HTTPResponse#header is obsolete
http header - last-modified:  - NilClass
```

## more cleanup

```
move test/data to a shared folder
see sportdb for a model?
```

## more warnings 

```
gems/pluto-models-1.5.1/lib/pluto/connecter.rb:19: warning: instance variable @debug not initialized
gems/pluto-models-1.5.1/lib/pluto/connecter.rb:19: warning: instance variable @debug not initialized
gems/pluto-models-1.5.1/lib/pluto/connecter.rb:19: warning: instance variable @debug not initialized

gems/feedparser-2.1.1/lib/feedparser/generator.rb:27: warning: instance variable @name not initialized
gems/feedparser-2.1.1/lib/feedparser/generator.rb:30: warning: instance variable @text not initialized
feedreader/pluto/pluto-models/lib/pluto/models/feed.rb:16: warning: instance variable @debug not initialized

gems/pluto-models-1.5.1/lib/pluto/models/feed.rb:57: warning: method redefined; discarding old author_email
gems/pluto-models-1.5.1/lib/pluto/models/feed.rb:56: warning: previous definition of author_email was here


gems/feedparser-2.1.1/lib/feedparser/builder/microformats.rb:174: warning: mismatched indentations at 'end' with 'def' at 149
gems/2.3.0/gems/feedparser-2.1.1/lib/feedparser/builder/microformats.rb:214: warning: shadowing outer local variable - h
gems/2.3.0/gems/feedparser-2.1.1/lib/feedparser/builder/microformats.rb:216: warning: shadowing outer local variable - h
```


## Models

- [ ]  rename Models to Model namespace!!

- [ ] add more helpers - link_to
- [ ] add more helpers - stylesheet

- [ ] add blockquote/quote/q ?? to whitelist

- [ ] allow link|feed   without leading http://

why?  shorter (unless its https:// redundant - the web is http by default)

Example:

```
[rubyflow]
  title  = Ruby Flow
  link   = http://rubyflow.com
  feed   = http://feeds.feedburner.com/Rubyflow?format=xml
```

becomes

```
[rubyflow]
  title  = Ruby Flow
  link   = rubyflow.com
  feed   = feeds.feedburner.com/Rubyflow?format=xml
```
