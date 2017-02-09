# TODOS - Notes, Ideas


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
