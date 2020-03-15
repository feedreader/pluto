require 'newscast'


News.config.database = './news.db'

puts "::::::::::::::::::::::::::::::::::::"
puts "::  #{News.channels.count} channels, #{News.items.count} items"



require_relative './barchart'



###
#  calculate (top) word frequency in headlines
#
#  todo/fix:  add report number of posts (for n=121 or something)

def headline_versioncount( year, name )
  freq_versions = {}

  ####
  ## todo/fix: limit 100 entries per feed max.
  ##   for word count  (rsoc has 600!)
  n = 0
  News.year( year ).each do |item|
    n += 1   ## track number of items (same as News.year( year ).count )
  ## words = item.title.downcase.split  ## split by space
  ##  words MUST be all a-z and can include _- inside
  ##     e.g. table-locking or
  ##          each_with_object

    ## avoid matching
    ##    Southeast Ruby 2020
    words = item.title.downcase.scan( /\b#{name}
                                        \s
                                       (?:[0-9]
                                           (?:\.[0-9]+)*
                                           (?:[.-][a-z][a-z0-9]+)?
                                       )
                                       (?![0-9])  ## negative lookahead (NOT followed by any numbers)
                                      /x )

    words = words.uniq

    if words.size > 0
      pp words
      print ">> "
      print item.title
      print "\n"


      words.each do |word|
        parts = word.split( /[.-]/ )
        key = if parts.size == 1
                   [parts[0],'0'].join('.')   ## assume 0 for now or keep separate - why? why not?
              elsif parts.size == 2
                   parts.join('.')
              else  ## cut-back (normalize) to two for now
                   parts[0..1].join('.')
              end

        freq_versions[ key ] ||= 0
        freq_versions[ key ] += 1
      end
    end
  end

  freq_versions = freq_versions.sort do |l,r|
    res = r[1]<=>l[1]                ## 1) by count
    res = l[0]<=>r[0]  if res == 0   ## 2) by key (a to z)
    res
  end

  [freq_versions, n]
end

puts "2019:"
ruby_2019, n_ruby_2019 = headline_versioncount( 2019, 'ruby' )
puts

puts "2020:"
ruby_2020, n_ruby_2020 = headline_versioncount( 2020, 'ruby' )
puts

puts "2019:"
rails_2019, n_rails_2019 = headline_versioncount( 2019, 'rails' )
puts

puts "2020:"
rails_2020, n_rails_2020 = headline_versioncount( 2020, 'rails' )
puts


pp ruby_2019
pp ruby_2020
puts

pp rails_2019
pp rails_2020



barchart( ruby_2019, title: "Top Ruby Versions in Headlines 2019", n: n_ruby_2019 )
barchart( ruby_2020, title: "Top Ruby Versions in Headlines 2020", n: n_ruby_2020 )

barchart( rails_2019, title: "Top Rails Versions in Headlines 2019", n: n_rails_2019 )
barchart( rails_2020, title: "Top Rails Versions in Headlines 2020", n: n_rails_2020 )



puts
puts "bye"


