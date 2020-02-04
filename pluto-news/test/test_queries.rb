###
#  to run use
#     ruby -I ./lib -I ./test test/test_queries.rb


require 'helper'

class TestQueries < MiniTest::Test

  def test_queries   
    puts News.channels.to_sql
    puts News.feeds.to_sql
    
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
    
    assert true    
  end

end  # class TestQueries
