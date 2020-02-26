
require 'pluto/update'


## todo/fix: include stdlibs in pluto/update or pluto/models upstream!!!
require 'date'
require 'time'
require 'cgi'
require 'uri'
require 'digest'

require 'erb'
require 'ostruct'



class Date
  ## def quarter() 1+(self.month-1)/3; end

  def quarter
    case self.month
    when 1,2,3    then 1
    when 4,5,6    then 2
    when 7,8,9    then 3
    when 10,11,12 then 4
    end
  end
end

# -- for testing:
# (1..12).each do |num|
#   puts "#{num} -> #{Date.new(2020,num,1).quarter}"
# end
# -- prints:
#   1 -> 1
#   2 -> 1
#   3 -> 1
#   4 -> 2
#   5 -> 2
#   6 -> 2
#   7 -> 3
#   8 -> 3
#   9 -> 3
#  10 -> 4
#  11 -> 4
#  12 -> 4



## our own code
require 'pluto/news/version'



module News

  def self.site=(value)  @site   = value;  end
  def self.site()        @site ||= 'news'; end   ## note: defaults to news



  def self.subscribe( *feeds )
    site_hash = {        ## note: keys are strings (NOT symbols) for now
      'title' => 'Untitled'
    }

    feeds.each_with_index do |feed|
      ## note:
      ##   use a "fingerprint" hash digest as key
      ##     do NOT include scheme (e.g. https or http)
      ##     do NOT include port
      ##   so you can change it without "breaking" the key - why? why not?
      ##
      ##  e.g.   u = URI( 'https://example.com:333/a/b?f=xml'
      ##          u.host+u.request_uri
      ##         #=> example.com/a/b?f=xml
      uri = URI( feed )
      ## note: add host in "plain" text - making errors and the key more readable
      ## note: cut-off www. if leading e.g. www.ruby-lang.org => ruby-lang.org
      host = uri.host.downcase.sub( /^www\./, '' )
      #   use a differt separator e.g _ or ~ and NOT $ - why? why not?
      key = "#{host}$#{Digest::MD5.hexdigest( uri.request_uri )}"

      site_hash[ key ] = { 'feed'  => feed }
    end

    connection   ## make sure we have a database connection (and setup) up-and-running
    ## note: always use "multi-site" setup; defaults to 'news' site key
    Pluto::Model::Site.deep_create_or_update_from_hash!( site, site_hash )
  end

  def self.update
    connection   ## make sure we have a database connection (and setup) up-and-running
    Pluto.update_feeds
  end
  def self.refresh() update; end    ## convenience alias for update



  def self.feeds
    connection
    ## note: always use "multi-site" setup; defaults to 'news' site key
    ## note: add "default" scope - orders (sorts) by latest / time
    rec = Pluto::Model::Site.where(key: site).first
    if rec.nil?
      Pluto::Model::Feed.none     ## use null (relation) pattern to avoid crash on nil - why? why not?
    else
      rec.feeds.order(
        Arel.sql( "coalesce(feeds.updated,feeds.published,'1970-01-01') desc" )
      )
    end
  end
  def self.channels()  feeds; end   ## convenience alias for feeds


  def self.items
    connection    ## make sure we have a database connection (and setup) up-and-running
    ## note: always use "multi-site" setup; defaults to 'news' site key
    ## note: add "default" scope - orders (sorts) by latest / time
    rec = Pluto::Model::Site.where(key: site).first
    if rec.nil? 
      Pluto::Model::Item.none    ## use null (relation) pattern to avoid crash on nil - why? why not?
    else
      rec.items.order(
        Arel.sql( "coalesce(items.updated,items.published,'1970-01-01') desc" )
      )
    end
  end
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

  def self.quarter( quarter=Date.today.quarter, year=Date.today.year )
    case quarter
    when 1 then between( Date.new( year,  1, 1), Date.new( year, 3, 31) );
    when 2 then between( Date.new( year,  4, 1), Date.new( year, 6, 30) );
    when 3 then between( Date.new( year,  7, 1), Date.new( year, 9, 30) );
    when 4 then between( Date.new( year, 10, 1), Date.new( year,12, 31) );
    else  raise ArgumentError
    end
  end

  def self.quarter1( year=Date.today.year ) quarter(1, year); end
  def self.quarter2( year=Date.today.year ) quarter(2, year); end
  def self.quarter3( year=Date.today.year ) quarter(3, year); end
  def self.quarter4( year=Date.today.year ) quarter(4, year); end

  def self.q( quarter=Date.today.quarter, year=Date.today.year ) quarter( quarter, year ); end
  def self.q1( year=Date.today.year ) quarter1( year ); end
  def self.q2( year=Date.today.year ) quarter2( year ); end
  def self.q3( year=Date.today.year ) quarter3( year ); end
  def self.q4( year=Date.today.year ) quarter4( year ); end


  def self.year( year=Date.today.year )
    q = year
    items.
      where(
        Arel.sql( "strftime('%Y', coalesce(items.updated,items.published,'1970-01-01')) = '#{q}'" )
      )
  end




  def self.this_week()    week;    end   ## convenience alias - keep - why? why not?
  def self.this_month()   month;   end
  def self.this_quarter() quarter; end
  def self.this_year()    year;    end



  class Template
    class Context < OpenStruct
      ## use a different name - why? why not?
      ##  e.g. to_h, to_hash, vars, locals, assigns, etc.
      def get_binding() binding; end

      ## add builtin helpers / shortcuts
      def h( text ) CGI.escapeHTML( text ); end
    end # class Template::Context


    def initialize( text )
      @template = ERB.new( text )
    end

    ## todo: use locals / assigns or something instead of **kwargs - why? why not?
    ##        allow/support (extra) locals / assigns - why? why not?
    def render( **kwargs )
      ## note: Ruby >= 2.5 has ERB#result_with_hash - use later - why? why not?
      @template.result( Context.new( **kwargs ).get_binding )
    end
  end # class Template

  def self.render( text, **kwargs )
    template = Template.new( text )
    template.render( **kwargs )
  end




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




# say hello
puts PlutoNews.banner   if $DEBUG || (defined?($RUBYLIBS_DEBUG) && $RUBYLIBS_DEBUG)
