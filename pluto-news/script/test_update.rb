###
#  to run use
#     ruby -I ./lib script/test_update.rb


require 'pluto/news'


# News.configure do |config|
#   config.database = ':memory:'
# end


News.subscribe(
  'http://www.ruby-lang.org/en/feeds/news.rss',     # Ruby Lang News
  'http://www.jruby.org/atom.xml',                  # JRuby Lang News
  'http://blog.rubygems.org/atom.xml',              # RubyGems News
  'http://bundler.io/blog/feed.xml',                # Bundler News
  'https://www.ruby-toolbox.com/blog.rss',          # Ruby Toolbox News
  'https://idiosyncratic-ruby.com/feed.xml',        # Idiosyncratic Ruby
  'http://weblog.rubyonrails.org/feed/atom.xml',    # Ruby on Rails News
  'http://sinatrarb.com/feed.xml',                  # Sinatra News
  'https://dry-rb.org/feed.xml',                    # DRY News
  'https://hanamirb.org/atom.xml',                  # Hanami News
  'http://jekyllrb.com/feed.xml',                   # Jekyll News
  'http://feeds.feedburner.com/jetbrains_rubymine?format=xml',  # RubyMine IDE News
  'https://blog.phusion.nl/rss/',                   # Phusion News
  'https://rubyinstaller.org/feed.xml',             # Ruby Installer for Windows News

  'http://planetruby.github.io/calendar/feed.xml',  # Ruby Conferences & Camps News
  'https://rubytogether.org/news.xml',              # Ruby Together News
  'https://foundation.travis-ci.org/feed.xml',      # Travis Foundation News
  'https://railsgirlssummerofcode.org/blog.xml',    # Rails Girls Summer of Code News

   ## Ruby People ++ Personal Blog / Website
  'http://blog.zenspider.com/atom.xml',          # Ryan Davis @ Seattle › Washington › United States
  'http://tenderlovemaking.com/atom.xml',        # Aaron Patterson @ Seattle › Washington › United States
  'http://blog.headius.com/feed.xml',            # Charles Nutter @ Richfield › Minnesota › United States
  'http://www.schneems.com/feed.xml',            # Richard Schneeman @ Austin › Texas › United States
  'https://developers.redhat.com/blog/author/vnmakarov/feed/',  # Vladimir Makarov @ Toronto › Canada

  'https://eregon.me/blog/feed.xml',             # Benoit Daloze @ Zürich › Switzerland
  'https://gettalong.org/posts.atom',            # Thomas Leitner @ Vienna • Wien › Austria
  'https://rubytuesday.katafrakt.me/feed.xml',   # Paweł Świątkowski @ Kraków, Poland
  'https://solnic.codes/feed/',                  # Piotr Solnica @ Kraków › Poland
  'https://zverok.github.io/feed.xml',           # Victor Shepelev @ Kharkiv › Ukraine

  'http://samsaffron.com/posts.rss',             # Sam Saffron @ Sydney › Australia
  'https://www.rubypigeon.com/feed.xml',         # Tom Dalling @ Melbourne› Australia
  )

News.update

