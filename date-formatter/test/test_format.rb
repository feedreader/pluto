###
#  to run use
#     ruby -I ./lib -I ./test test/test_format.rb


require 'helper'

class TestFormat < MiniTest::Test

   def test_format
     dates = { 'January 02, 2006'        => '%B %d, %Y',
               'Mon, Jan 02'             => '%a, %b %d',
               '2 Jan 2006'              => '%-d %b %Y',
               'Monday, January 2, 2006' => '%A, %B %-d, %Y',
    
               'Mon, Jan 02 3:00'        => '%a, %b %d %-H:%M',
               '2 Jan 2006 03:00'        => '%-d %b %Y %H:%M',
               '2006'                    => '%Y',
    
               'YYYY-MM-DD' => ['%Y-%m-%d',  '2006-01-02'],
               'YY-MM-DD'   => ['%y-%m-%d',  '06-01-02'],
               'YY-MM-D'    => ['%y-%m-%-d', '06-01-2'],
    
               'YYYYMMDD'   => ['%Y%m%d',    '20060102'],
               'YYMMDD'     => ['%y%m%d',    '060102'],
               'YYMMD'      => ['%y%m%-d',   '06012'],
               'YYYY'       => ['%Y',        '2006'],
               
               'hh:mm:ss'   => ['%H:%M:%S',  '03:00:00'],
               'h:mm:ss'    => ['%-H:%M:%S', '3:00:00'],
               'hh:mm'      => ['%H:%M',     '03:00'],
            }
 
      dates.each do |date, exp|
         assert_format( date, exp )
      end
   end
 

   def assert_format( spec, exp )
      strf = DateByExample.to_strftime( spec )
      now = Time.new( 2006, 1, 2, 3 )   ## Mon, Jan 2, 3:00 2006
      str  = now.strftime( strf )

      puts "#{spec}  =>  #{strf}  =>  #{str}"

      if exp.is_a?( Array )
        exp_strf = exp[0]
        exp_str  = exp[1]
      else
        exp_strf = exp
        exp_str  = spec   ## same as passed in format specifier/string
      end
      
      assert_equal exp_strf, strf
      assert_equal exp_str,  str
   end
           
end  # class TestFormat