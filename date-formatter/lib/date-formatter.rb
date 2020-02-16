require 'pp'
require 'time'
require 'date'



###
# our own code
require 'date-formatter/version' # let version always go first



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

    ## add some "higher-level" symbolic format shortcuts too
    spec = spec.gsub( 'YYYY', '%Y' )
    spec = spec.gsub( 'YY',   '%y' )
    spec = spec.gsub( 'MM',   '%m' )
    spec = spec.gsub( 'DD',   '%d' )
    spec = spec.gsub( 'D',    '%-d')

    spec = spec.gsub( 'hh',   '%H' )
    spec = spec.gsub( 'h',    '%-H' )
    spec = spec.gsub( 'mm',   '%M' )
    spec = spec.gsub( 'ss',   '%S' )

    spec
  end
end



class String
  def to_strftime() DateByExample.to_strftime( self ); end
end

class Date
  def format( spec ) self.strftime( spec.to_strftime ); end
end

class DateTime
  def format( spec ) self.strftime( spec.to_strftime ); end
end

class Time
  def format( spec ) self.strftime( spec.to_strftime ); end
end


class NilClass
  def format( spec ) ''; end
end




# say hello
puts DateByExample.banner   if $DEBUG || (defined?($RUBYLIBS_DEBUG) && $RUBYLIBS_DEBUG)

