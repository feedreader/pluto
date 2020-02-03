require 'pluto/models'
require 'pluto/update'



module News

  def self.subscribe( *feeds )
    site_key  = 'news'   ## note: use always news (and single-site setup) for now
    site_hash = {        ## note: keys are strings (NOT symbols) for now
      'title' => 'News, News, News'
    }

    feeds.each_with_index do |feed,i|
      key = "feed%03d" % (i+1)
      ## todo/fix:
      ##  use auto_title and auto_link
      ##   do NOT add title and link (will overwrite/rule auto_title and auto_link updates)
      site_hash[ key ] = { 'title' => "Untitled %03d" % (i+1),
                           'link'  => 'http://example.com',   ## todo/fix - make optional?
                           'feed'  => feed
                         }
    end

    connection   ## make sure we have a database connection (and setup) up-and-running
    Pluto::Model::Site.deep_create_or_update_from_hash!( site_key, site_hash )
  end

  def self.update
    connection   ## make sure we have a database connection (and setup) up-and-running
    Pluto.update_feeds
  end
  def self.refresh() update; end    ## convenience alias for update



  def self.feeds
    connection
    ## note: add "default" scope - orders (sorts) by latest / time
    Pluto::Model::Feed.order(
        Arel.sql( "coalesce(feeds.updated,feeds.published,'1970-01-01') desc" )
      )
  end
  def self.channels()  feeds; end   ## convenience alias for feeds


  def self.items
    connection    ## make sure we have a database connection (and setup) up-and-running
    ## note: add "default" scope - orders (sorts) by latest / time
    Pluto::Model::Item.order(
        Arel.sql( "coalesce(items.updated,items.published,'1970-01-01') desc" )
      )
  end
  def self.articles()  items; end   ## convenience alias for articles
  def self.latest()    items; end   ## note: "default" scope orders (sorts) by latest / time


  def self.today
      ## todo: order by time!! - possible - why? why not?
      ## note: use date() to cut-off hours etc. if present?

      q = Date.today.strftime('%Y-%m-%d')   # e.g. 2020-02-20
      items.
        where(
          Arel.sql( "date(coalesce(items.updated,items.published)) = '#{q}'" )
        )
  end


  def self.between( start_date, end_date )   ## helper for week, q1, q2, etc.
    q_start = start_date.strftime('%Y-%m-%d')
    q_end   = end_date.strftime('%Y-%m-%d')

    items.
      where(
        Arel.sql( "date(coalesce(items.updated,items.published,'1970-01-01')) BETWEEN '#{q_start}' AND '#{q_end}'" )
      )
  end

  def self.week( week=Date.today.cweek, year=Date.today.year )
    ## note: SQLite only supports "classic" week of year (not ISO "commercial week" starting on monday - and not on sunday)
    ## %W - week of year: 00-53
    ## thus, needs to calculate start and end date!!!

    start_date = Date.commercial(year, week, 1)
    end_date   = Date.commercial(year, week, 7)

    between( start_date, end_date )
  end

  def self.month( month=Date.today.month, year=Date.today.year )
      q = "%4d-%02d" % [year,month]     # e.g. 2020-01 etc.
      items.
        where(
          Arel.sql( "strftime('%Y-%m', coalesce(items.updated,items.published,'1970-01-01')) = '#{q}'" )
        )
  end

  def self.year( year=Date.today.year )
    q = year
    items.
      where(
        Arel.sql( "strftime('%Y', coalesce(items.updated,items.published,'1970-01-01')) = '#{q}'" )
      )
  end

  def self.this_week()  week;  end    ## convenience alias - keep - why? why not?
  def self.this_month() month; end
  def self.this_year()  year;  end


  def self.q1( year=Date.today.year ) between( Date.new( year,  1, 1), Date.new( year, 3, 31) ); end
  def self.q2( year=Date.today.year ) between( Date.new( year,  4, 1), Date.new( year, 6, 30) ); end
  def self.q3( year=Date.today.year ) between( Date.new( year,  7, 1), Date.new( year, 9, 30) ); end
  def self.q4( year=Date.today.year ) between( Date.new( year, 10, 1), Date.new( year,12, 31) ); end



  class Configuration
     def database=(value) @database = value;  end
     def database()       @database || { adapter: 'sqlite3', database: './news.db' }; end
  end # class Configuration

  def self.configure
    yield( config )
  end

  def self.config
    @config ||= Configuration.new
  end


  class Connection
    def initialize    # convenience shortcut w/ automigrate
      config = if News.config.database.is_a?(Hash)
                    News.config.database
               else  ## assume a string (e.g. :memory:, or <path> AND sqlite3 adapter)
                    { adapter: 'sqlite3', database: News.config.database }
               end

      Pluto.connect( config )
      Pluto.auto_migrate!
    end
  end  # class Connection

  def self.connection     ## use for "auto-magic" connection w/ automigrate
    ##  todo/fix: check - "just simply" return ActiveRecord connection - possible - why? why not?
    ##                       do NOT use our own Connection class
    @connection ||= Connection.new
  end
end  # module News



# News.configure do |config|
#   config.database = ':memory:'
# end

=begin
News.subscribe(
  'http://www.ruby-lang.org/en/feeds/news.rss',     # Ruby Lang News
  'http://www.jruby.org/atom.xml',                  # JRuby Lang News
  'http://blog.rubygems.org/atom.xml',              # RubyGems News
  'http://bundler.io/blog/feed.xml',                # Bundler News
  'http://weblog.rubyonrails.org/feed/atom.xml',    # Ruby on Rails News
  'http://sinatrarb.com/feed.xml',                  # Sinatra News
  'https://hanamirb.org/atom.xml',                  # Hanami News
  'http://jekyllrb.com/feed.xml',                   # Jekyll News
  'http://feeds.feedburner.com/jetbrains_rubymine?format=xml',  # RubyMine IDE News
  'https://blog.phusion.nl/rss/',                   # Phusion News
  'https://rubyinstaller.org/feed.xml',             # Ruby Installer for Windows News
  'http://planetruby.github.io/calendar/feed.xml',  # Ruby Conferences & Camps News
  'https://rubytogether.org/news.xml',              # Ruby Together News

  'http://blog.zenspider.com/atom.xml',          # Ryan Davis @ Seattle, WA › United States
  'http://tenderlovemaking.com/atom.xml',        # Aaron Patterson @ Seattle, WA › United States
  'http://blog.headius.com/feed.xml',            # Charles Nutter @ Richfield, MN › United States
  'http://www.schneems.com/feed.xml',            # Richard Schneeman @ Austin, TX › United States
  )


News.update
=end


puts News.channels.to_sql
puts News.feeds.to_sql

puts News.articles.to_sql
puts News.items.to_sql




puts News.latest.limit(2).to_sql
puts News.today.to_sql

puts News.week.to_sql
puts News.week( 1 ).to_sql
puts News.week( 1, 2019 ).to_sql

puts News.month.to_sql
puts News.month( 1 ).to_sql
puts News.month( 1, 2019 ).to_sql

puts News.year.to_sql
puts News.year( 2019 ).to_sql

puts News.this_week.to_sql
puts News.this_month.to_sql
puts News.this_year.to_sql

puts News.q1.to_sql
puts News.q2.to_sql
puts News.q3.to_sql
puts News.q4.to_sql


###### run queries
pp News.latest.limit(2).to_a
pp News.today.to_a

pp News.week.to_a
pp News.week( 1 ).to_a
pp News.week( 1, 2019 ).to_a

pp News.month.to_a
pp News.month( 1 ).to_a
pp News.month( 1, 2019 ).to_a

pp News.year.to_a
pp News.year( 2019 ).to_a

pp News.this_week.to_a
pp News.this_month.to_a
pp News.this_year.to_a

pp News.q1.to_a
pp News.q2.to_a
pp News.q3.to_a
pp News.q4.to_a


puts ":::::::::::::::::::::::::::::::::::::::::::::::::::"
puts ":: #{News.items.count} news items from #{News.channels.count} channels:"
puts

puts "By Year:"
(2010..Date.today.year).each do |year|
  puts "  year #{year}: #{News.year(year).count}"
end
puts

puts "By Month in #{Date.today.year}:"
(1..Date.today.month).each do |month|
  puts "  month #{month}: #{News.month(month).count}"
end
puts

puts "By Week in #{Date.today.year}:"
(1..Date.today.cweek).each do |week|
  print "  week %-2d: %4d" % [week, News.week(week).count]
  print "\n"
end
puts

year = Date.today.year-1
puts "By Week in #{year}:"
(1..52).each do |week|    ## (always) assume 52 weeks for now
  print "  week %-2d: %4d" % [week, News.week(week, year).count]
  print "   - #{Date.commercial(year,week,1)} to #{Date.commercial(year,week,7)}"
  print "\n"
end
puts


puts "This Year:    #{News.this_year.count}"
puts "This Month:   #{News.this_month.count}"
puts "This Week:    #{News.this_week.count}"
puts "Today:        #{News.today.count}"
puts

puts "100 Latest News Items"
News.latest.limit( 100 ).each do |item|
  print "%4dd " % (Date.today.jd-item.updated.to_date.jd)
  print "  #{item.updated}"
  print " - #{item.title}"
  print " - #{item.feed.feed_url}"   ## fix: use title or something
  print "\n"
end
puts

puts "Channels"
News.channels.each do |channel|
  if channel.updated?
    print "%4dd " % (Date.today.jd-channel.updated.to_date.jd)
  else
    print "   ?  "
  end
  print "  #{channel.updated}"
  print " - %4d" % channel.items.count
  print " - #{channel.feed_url}"   ## fix: use title or something
  print "\n"
end

## use/add feeds.items_updated to coalesce updated - why?, why not?


