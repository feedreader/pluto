###
#  to run use
#     ruby -I ./lib script/test_usage.rb


require 'date/formatter'


################
#  String#to_strftime

p 'January 02, 2006'.to_strftime          #=> "%B %d, %Y"
p 'Mon, Jan 02'.to_strftime               #=> "%a, %b %d"
p '2 Jan 2006'.to_strftime                #=> "%-d %b %Y"
p 'Monday, January 2, 2006'.to_strftime   #=> "%A, %B %-d, %Y"

p 'Mon, Jan 02 3:00'.to_strftime          #=> "%a, %b %d %-H:%M"
p '2 Mon 2006 03:00'.to_strftime          #=> "%-d %b %Y %H:%M"

####################
#  Date#format

date = Date.new( 2020, 2, 9 )
p date.format( 'January 02, 2006' )         #=> "February 09, 2020"
p date.format( 'Mon, Jan 02' )              #=> "Sun, Feb 09"
p date.format( '2 Jan 2006' )               #=> "9 Feb 2020"
p date.format( 'Monday, January 2, 2006' )  #=> "Sunday, February 9, 2020"


#####################
#  Time#format

time = Time.new( 2020, 2, 9 )

p time.format( 'January 02, 2006' )         #=> "February 09, 2020"
p time.format( 'Mon, Jan 02' )              #=> "Sun, Feb 09"
p time.format( '2 Jan 2006' )               #=> "9 Feb 2020"
p time.format( 'Monday, January 2, 2006' )  #=> "Sunday, February 9, 2020"

p time.format( 'Mon, Jan 02 3:00' )         #=> "Sun, Feb 09 0:00"
p time.format( '2 Mon 2006 03:00' )         #=> "9 Sun 2020 00:00"


#######################
#   NilClass#format

p nil.format( 'January 02, 2006' )         #=> ""

