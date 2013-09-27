# encoding: UTF-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_rss.rb
#  or better
#     rake test

require 'helper'

class TestHelper < MiniTest::Unit::TestCase

  include Pluto::TemplateHelper   #  lets us use textify, etc.

  def test_textify
    hyin =<<EOS
<p><img style="float:left; margin-right:4px" src="http://photos1.meetupstatic.com/photos/event/7/c/b/2/event_244651922.jpeg" alt="photo" class="photo" />vienna.rb</p>
<p>
  <p>The cool guys from <a href="http://platogo.com/">Platogo</a> will sponsor (y)our drinks. Which is awesome.</p>
  <p><strong>Talks</strong>*</p>
  <p>Jakob Sommerhuber - sponsor talk</p>
  <p>Martin Schürrer - Erlang/OTP in production for highly-available, scalable systems</p>
  <p>Markus Prinz - How to improve your code</p>
  <p>Gerald Bauer - working with Sinatra</p>
  <p>Kathrin Folkendt - 'Chapter one' (lightning talk on getting started with Rails, and building her first web app)</p>
  <p><em>*preliminary program</em></p>
</p>
<p>Vienna   - Austria</p>
<p>Friday, October 11 at 6:00 PM</p>
<p>Attending: 21</p>
<p>Details: http://www.meetup.com/vienna-rb/events/130346182/</p>
EOS

    hyout = <<EOS
<p>♦vienna.rb</p>
<p>
  <p>The cool guys from Platogo will sponsor (y)our drinks. Which is awesome.</p>
  <p>Talks*</p>
  <p>Jakob Sommerhuber - sponsor talk</p>
  <p>Martin Schürrer - Erlang/OTP in production for highly-available, scalable systems</p>
  <p>Markus Prinz - How to improve your code</p>
  <p>Gerald Bauer - working with Sinatra</p>
  <p>Kathrin Folkendt - 'Chapter one' (lightning talk on getting started with Rails, and building her first web app)</p>
  <p>*preliminary program</p>
</p>
<p>Vienna   - Austria</p>
<p>Friday, October 11 at 6:00 PM</p>
<p>Attending: 21</p>
<p>Details: www.meetup.com/vienna-rb/events/130346182/</p>
EOS

    out = textify( hyin )
    
    puts '==================>'
    puts out
    puts '<=================='
    
    assert( out == hyout)
  end

end # class TestHelper