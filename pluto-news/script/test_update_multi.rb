###
#  to run use
#     ruby -I ./lib script/test_update_multi.rb


require 'pluto/news'


News.site = 'nytimes'

News.subscribe( <<TXT )
[NYT > Technology]
  feed = http://feeds.nytimes.com/nyt/rss/Technology
[Bits Blog]
  feed = http://bits.blogs.nytimes.com/feed/
[Open Blog]
  feed = http://open.blogs.nytimes.com/feed/
TXT



News.site = 'lang'

feeds = INI.load( <<TXT )
[Ruby Lang News]
  feed = http://www.ruby-lang.org/en/feeds/news.rss
[Go Lang News]
  feed = http://blog.golang.org/feed.atom
[Rust Lang News]
  feed = http://blog.rust-lang.org/feed.xml
[Erlang News]
  feed = http://www.erlang.org/rss
[Elixir Lang News]
  feed = http://feeds.feedburner.com/ElixirLang
[Julia Lang News]
  feed = http://feeds.feedburner.com/JuliaLang
[Lua Lang News]
  feed = http://www.lua.org/news.rss
[Idris Lang News]
  feed = http://www.idris-lang.org/feed/
[Swift Lang News]
  feed = https://developer.apple.com/swift/blog/news.rss

# Multi-lang Sites Research
[Lambda the Ultimate]
  feed = http://lambda-the-ultimate.org/rss.xml
TXT

News.subscribe( feeds )


News.update


