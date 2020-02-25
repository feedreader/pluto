###
#  to run use
#     ruby -I ./lib script/test_update_multi.rb


require 'pluto/news'


News.site = 'nytimes'

News.subscribe(
  'http://feeds.nytimes.com/nyt/rss/Technology',    # NYT > Technology
  'http://bits.blogs.nytimes.com/feed/',            # Bits Blog
  'http://open.blogs.nytimes.com/feed/',            # Open Blog
)


News.site = 'lang'

News.subscribe(
  'http://www.ruby-lang.org/en/feeds/news.rss',      # Ruby Lang News
  'http://blog.golang.org/feed.atom',                # Go Lang News
  'http://blog.rust-lang.org/feed.xml',              # Rust Lang News
  'http://www.erlang.org/rss',                       # Erlang News
  'http://feeds.feedburner.com/ElixirLang',          # Elixir Lang News
  'http://feeds.feedburner.com/JuliaLang',           # Julia Lang News
  'http://www.lua.org/news.rss',                     # Lua Lang News
  'http://www.idris-lang.org/feed/',                 # Idris Lang News
  'https://developer.apple.com/swift/blog/news.rss', # Swift Lang News

   # Multi-lang Sites Research
  'http://lambda-the-ultimate.org/rss.xml',          # Lambda the Ultimate
)



News.update


