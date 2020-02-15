require 'pp'
require 'time'
require 'date'



module DateByExample

##
## todo/fix: improve end of MONTH_RE
##   do NOT use \b - also break on everything but a-z incl. numbers/digits - (double) check!!!

  MONTH_NAME_ABBREV_RE = %r<
     \b(
        Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec
       )\b
    >x


  ## note: May is turned into an abbreviated month name (%b)
  MONTH_NAME_RE = %r<
      \b(
        January|February|March|
        April|June|              ## note: May is "ambigious" and, thus, NOT included
        July|August|September|
        October|November|December
        )\b
    >x

  DAY_NAME_ABBREV_RE = %r<
     \b(
       Mon|Tue|Wed|Thu|Fri|Sat|Sun
       )\b
    >x

  DAY_NAME_RE = %r<
     \b(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)\b
    >x

  YEAR_RE = %r<
     \b([12][0-9][0-9][0-9])\b
    >x

  DAY_WITH_ZERO_RE = %r<
      \b(0[1-9])\b
    >x

  DAY_RE = %r<
      \b([1-9]|[123][0-9])\b
    >x

  TIME_WITH_ZERO_RE = %r<
       \b(0[0-9]:[0-9][0-9])\b
    >x

  TIME_RE = %r<
    \b(([1-9]|[12][0-9]):[0-9][0-9])\b
    >x


  def self.to_strftime( spec )
    spec = spec.gsub( MONTH_NAME_RE, '%B' )         # %B - The full month name ("January")
    spec = spec.gsub( MONTH_NAME_ABBREV_RE, '%b')   # %b - The abbreviated month name ("Jan")
    spec = spec.gsub( DAY_NAME_RE, '%A' )           # %A - The full weekday name ("Sunday")
    spec = spec.gsub( DAY_NAME_ABBREV_RE, '%a')     # %a - The abbreviated weekday name ("Sun")

    spec = spec.gsub( TIME_WITH_ZERO_RE, '%H:%M' )  # %H - Hour of the day, 24-hour clock (00..23)
                                                    # %M - Minute of the hour (00..59)
    spec = spec.gsub( TIME_RE, '%-H:%M' )

    spec = spec.gsub( YEAR_RE, '%Y' )               # %Y - Year with century
    spec = spec.gsub( DAY_WITH_ZERO_RE, '%d' )      # %d - Day of the month (01..31)
    spec = spec.gsub( DAY_RE, '%-d' )               # %d - Day of the month without a leading zero (1..31)

    ## add some "higher-level" format shortcuts too
    spec = spec.gsub( 'YYYY', '%Y' )
    spec = spec.gsub( 'YY',   '%y' )
    spec = spec.gsub( 'MM',   '%m' )
    spec = spec.gsub( 'DD',   '%d' )
    spec = spec.gsub( 'D',    '%-d')

    spec
  end
end


###
#  String#to_strfime
#

#  Date#format
#  Time#format
#  DateTime#format


## test with
#    January 04, 2010
#    Fri, Jan 04
#    4 Jan 2010
#    Friday, January 4, 2010
#    ...

def test_format( spec )
  strf = DateByExample.to_strftime( spec )
  now = Time.new( 2020, 1, 1 )
  str  = now.strftime( strf )

  puts "#{spec}  =>  #{strf}  =>  #{str}"
end

test_format( 'January 04, 2010' )
test_format( 'Fri, Jan 04' )
test_format( '4 Jan 2010' )
test_format( 'Friday, January 4, 2010' )

test_format( 'Fri, Jan 04 8:00' )
test_format( '4 Jan 2010 08:00' )

test_format( 'YYYY-MM-DD' )
test_format( 'YY-MM-DD' )
test_format( 'YY-MM-D' )

test_format( 'YYYYMMDD' )
test_format( 'YYMMDD' )
test_format( 'YYMMD' )



class String
  def to_strftime() DateByExample.to_strftime( self ); end
end

## usage

p 'January 04, 2010'.to_strftime          #=> "%B %d, %Y"
p 'Fri, Jan 04'.to_strftime               #=> "%a, %b %d"
p '4 Jan 2010'.to_strftime                #=> "%-d %b %Y"
p 'Friday, January 4, 2010'.to_strftime   #=> "%A, %B %-d, %Y"

p 'Fri, Jan 04 8:00'.to_strftime          #=> "%a, %b %d %-H:%M"
p '4 Jan 2010 08:00'.to_strftime          #=> "%-d %b %Y %H:%M"



class Date
  def format( spec ) self.strftime( spec.to_strftime ); end
end

## usage

date = Date.new( 2020, 2, 9 )
p date.format( 'January 04, 2010' )         #=> "February 09, 2020"
p date.format( 'Fri, Jan 04' )              #=> "Sun, Feb 09"
p date.format( '4 Jan 2010' )               #=> "9 Feb 2020"
p date.format( 'Friday, January 4, 2010' )  #=> "Sunday, February 9, 2020"


class DateTime
  def format( spec ) self.strftime( spec.to_strftime ); end
end

class Time
  def format( spec ) self.strftime( spec.to_strftime ); end
end

time = Time.new( 2020, 2, 9 )
p time.format( 'January 04, 2010' )         #=> "February 09, 2020"
p time.format( 'Fri, Jan 04' )              #=> "Sun, Feb 09"
p time.format( '4 Jan 2010' )               #=> "9 Feb 2020"
p time.format( 'Friday, January 4, 2010' )  #=> "Sunday, February 9, 2020"


class NilClass
  def format( spec ) ''; end
end

p nil.format( 'January 04, 2010' )  #=> ""





now = Time.now
p now.format( 'hello, time!' )
p now.format( 'Mon, Jan 01' )
p now.format( '%H' )
p now
puts now

today = Date.today
p today.format( 'hello, date!' )
p today.format( '%Y' )
p today
puts today

p today.to_datetime.format( 'hello, datetime!' )
p today.to_datetime
puts today.to_datetime

t = nil
puts  t.format( 'hello, date!' )


p    Time.now
puts Time.now

p    DateTime.now
puts DateTime.now
