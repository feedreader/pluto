###
#  to run use
#     ruby -I ./lib script/test_misc.rb


require 'date/formatter'


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
