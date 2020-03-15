require 'newscast'
require 'barcharts'



News.config.database = './news.db'



def collect_http_stats
  servers    = {}

  News.channels.each do |channel|
    server = channel.http_server ? channel.http_server : '?'
    server_key = if server =~ /apache/i
                      'Apache'
                 elsif server =~ /nginx/i
                      'Nginx'
                 elsif server =~ /cloudflare/i
                      'Cloudflare'
                 elsif server =~ /simplecast/i
                      'Simplecast'
                 elsif server =~ /gse/i
                      'Google Servlet Engine (GSE)'
                 elsif server =~ /amazons3/i
                      'Amazon S3'
                 else
                       server  ## pass through as is
                 end

    servers[ server_key ] ||= { count: 0 }
    servers[ server_key ][ :count ] += 1

    servers[ server_key ][ server ] ||= 0   ## keep track (count) of "full" server strings
    servers[ server_key ][ server ] += 1
  end

  ## return hash with all (more) stats
  { servers: servers }
end


def collect_feed_stats
  formats    = {}
  generators = {}

  News.channels.each do |channel|
    format = channel.format ? channel.format : '?'
    formats[ format ] ||= 0
    formats[ format ] += 1


    generator = channel.generator ? channel.generator : '?'
    generator_key = if generator =~ /jekyll/i
                      'Jekyll'
                 elsif generator =~ /hugo/i
                      'Hugo'
                 elsif generator =~ /ghost/i
                      'Ghost'
                 elsif generator =~ /wordpress/i
                      'WordPress'
                 elsif generator =~ /webgen/i
                      'Webgen'
                 elsif generator =~ /transistor/i
                      'Transistor'
                 elsif generator =~ /simplecast/i
                      'Simplecast'
                 else
                       generator  ## pass through as is
                 end

    generators[ generator_key ] ||= { count: 0 }
    generators[ generator_key ][ :count ] += 1

    generators[ generator_key ][ generator ] ||= 0   ## keep track (count) of "full" server strings
    generators[ generator_key ][ generator ] += 1
  end

  ## return hash with all (more) stats
  { formats:    formats,
    generators: generators }
end




def collect_freq_stats
  freq_medians      = {
    '<=   7 days' => { count: 0 },
    '<=  14 days' => { count: 0 },
    '<=  30 days' => { count: 0 },
    '<=  90 days' => { count: 0 },
    '<= 180 days' => { count: 0 },
    '<= 365 days' => { count: 0 },
    'above      ' => { count: 0 },
  }    # min. fequency of posts (every week, every month, etc.)


  News.channels.each do |channel|
    dates = channel.items.reduce( [] ) do |ary,item|
                                          if item.published
                                            ary << item.published.to_date.jd
                                          end
                                          ary
                                     end
    ## pp dates
    dates = dates.sort.reverse
    ## pp dates

    diff = channel.items.count - dates.size
    if diff > 0
      puts "!!!! WARN - #{diff} dates missing !!!!"
    end

    if dates.size > 1
      days = []
      last_date = nil
      dates.each_with_index do |date,i|
        if i > 0
          days << last_date - date
        end
        last_date = date
      end
      days = days.sort.reverse
      ## pp days

      ## note: use simple median compute (if even do NOT compute average for now)
      ## note: When there are an even number of elements, the smaller of the two middle elements is given.
      days_median = days[ (days.size / 2).to_i ]
      days_max    = days[0]

      days_diff     =  dates[0] - dates[-1]
      days_average  =  days_diff / channel.items.count
    else
      days          = nil
      days_per_post = nil
    end

    if days   ## note: skip invalid feeds without any dates (fix!!!!)
      freq      = days_median
      freq_key  = if days_median <= 7
                    '<=   7 days'
                  elsif days_median <= 14
                    '<=  14 days'
                  elsif days_median <= 30
                    '<=  30 days'
                  elsif days_median <= 90
                    '<=  90 days'
                  elsif days_median <= 180
                    '<= 180 days'
                  elsif days_median <= 365
                    '<= 365 days'
                  else
                    'above      '
                    ## raise ArgumentError.new( "out-of-bound - #{days_median} days" )
                  end

      freq_medians[ freq_key ] ||= { count: 0 }
      freq_medians[ freq_key ][ :count ] += 1

      freq_medians[ freq_key ][ freq ] ||= 0   ## keep track (count) of "full" server strings
      freq_medians[ freq_key ][ freq ] += 1
    end
  end

  { freq_medians: freq_medians }
end



def print_volume_stats
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

  year = Date.today.year
  puts "By Week in #{year}:"
  (1..Date.today.cweek).each do |week|
    print "  week %2d: %4d" % [week, News.week(week).count]
    print "   - #{Date.commercial(year,week,1).strftime('%a %b %d, %Y')} to #{Date.commercial(year,week,7).strftime('%a %b %d, %Y')}"
    print "\n"
  end
  puts

=begin
year = Date.today.year-1
puts "By Week in #{year}:"
(1..52).each do |week|    ## (always) assume 52 weeks for now
  print "  week %2d: %4d" % [week, News.week(week, year).count]
  print "   - #{Date.commercial(year,week,1).strftime('%a %b %d, %Y')} to #{Date.commercial(year,week,7).strftime('%a %b %d, %Y')}"
  print "\n"
end
puts
=end


  puts "This Year:    #{News.this_year.count}"
  puts "This Quartal: #{News.this_quarter.count}"
  puts "This Month:   #{News.this_month.count}"
  puts "This Week:    #{News.this_week.count}"
  puts "Today:        #{News.today.count}"
  puts
end






puts "::::::::::::::::::::::::::::::::::::"
puts "::  #{News.channels.count} channels, #{News.items.count} items"

stats = collect_feed_stats
pp stats

puts
barchart( stats[:formats], title: 'Formats', sort: true )
puts
barchart( stats[:generators], title: 'Generators', sort: true )


stats = collect_http_stats
pp stats

puts
barchart( stats[:servers], title: 'Servers', sort: true )


stats = collect_freq_stats
pp stats

puts
barchart( stats[:freq_medians], title: 'Update Frequency (Median)' )


print_volume_stats


puts
puts "bye"


