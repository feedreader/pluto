require 'date'
require 'time'

###
# from planet
#
#   date_iso ... date and time of the entry in { ISO date format
#
#
#   date_822 ...                               { RFC822 date format
#
#   ex: Sun, 06 Sep 2009 16:20:00 +0000
#       Sat, 07 Sep 2002 00:00:01 GMT

# from h-entry
#    - the ISO8601 machine-readable date
#   ex: 2013-06-13 12:00:00
#

# from rss 2.0
#   - All date-times in RSS conform to the Date and Time Specification
#      of RFC 822, with the exception that the year may be expressed
#      with two characters or four characters (four preferred).

# from atom
#
#


#
# ruby Datetime
#   iso8601() → string
#    or xmlschema([n=0]) → string
# This method is equivalent to strftime('%FT%T%:z').
#
#   rfc3339() → string
# This method is equivalent to strftime('%FT%T%:z').
#
#   httpdate()
# This method is equivalent to strftime('%a, %d %b %Y %T GMT').
#   See also RFC 2616.
#
#   rfc2822 → string
#   rfc822 → string
# This method is equivalent to strftime('%a, %-d %b %Y %T %z').
#
#  https://www.ietf.org/rfc/rfc2822.txt
#  https://www.w3.org/Protocols/rfc822/#z28


p Date.today.iso8601         #=> "2020-02-13"
p Date.today.xmlschema       #=> "2020-02-13"
p Date.today.rfc3339         #=> "2020-02-13T00:00:00+00:00"
p Date.today.httpdate        #=> "Thu, 13 Feb 2020 00:00:00 GMT"
# p Date.today.rfc2882         #=> undefined method `rfc2882' for #<Date>
p Date.today.rfc822          #=> "Thu, 13 Feb 2020 00:00:00 +0000"
puts

p Date.today.to_datetime.iso8601         #=> "2020-02-13T00:00:00+00:00"
p Date.today.to_datetime.xmlschema       #=> "2020-02-13T00:00:00+00:00"
p Date.today.to_datetime.rfc3339         #=> "2020-02-13T00:00:00+00:00"
p Date.today.to_datetime.httpdate        #=> "Thu, 13 Feb 2020 00:00:00 GMT"
# p Date.today.to_datetime.rfc2882         #=> undefined method `rfc2882' for #<DateTime>
p Date.today.to_datetime.rfc822          #=>"Thu, 13 Feb 2020 00:00:00 +0000"

puts
p Time.now.iso8601         #=> "2020-02-13T16:37:27+01:00"
p Time.now.xmlschema       #=> "2020-02-13T16:37:27+01:00"
# p Time.now.rfc3339         #=> undefined method `rfc3339' for #<Time>
p Time.now.httpdate        #=> "Thu, 13 Feb 2020 15:58:15 GMT"
# p Time.now.rfc2882         #=> undefined method `rfc2882' for #<Time>
p Time.now.rfc822            #=> "Thu, 13 Feb 2020 16:59:46 +0100"

###
p Date.new( 2020, 1, 2 ).httpdate            #=> "Thu, 02 Jan 2020 00:00:00 GMT"
p Date.new( 2020, 1, 2 ).rfc822              #=> "Thu, 2 Jan 2020 00:00:00 +0000"
p Date.new( 2020, 1, 2 ).iso8601             #=> "2020-01-02"
p Date.new( 2020, 1, 2 ).to_time.iso8601     #=> "2020-01-02T00:00:00+01:00"
p Date.new( 2020, 1, 2 ).to_datetime.iso8601 #=> "2020-01-02T00:00:00+00:00"
