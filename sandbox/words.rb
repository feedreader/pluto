#######
# todo:
#   to sort use:
#       cat words.txt | sort > words_az.txt


# more todos:
#
#  check again - opml gems !!!
#

# add feedchecker gem !!!
# add newsbase gem !!!


require 'pluto/news'


News.config.database = './news.db'

puts "::::::::::::::::::::::::::::::::::::"
puts "::  #{News.channels.count} channels, #{News.items.count} items"



require_relative './barchart'


countries = {}
News.channels.each do |channel|
  next if channel.location.nil?

  geo = channel.location.split( /[<>›]/ )
  country = geo[-1].strip   ## assume last entry is country

  countries[ country ] ||= 0
  countries[ country ] += 1
end

countries = countries.sort_by { |k,v| k }  ## sort by key (country name)
pp countries


barchart( countries, title: "Location (Personal Blogs)" )



__END__

###
#  calculate (top) word frequency in headlines
#
#  todo/fix:  add report number of posts (for n=121 or something)

def headline_wordcount( year, whitelist: )
  freq_words = {}

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
    words = item.title.downcase.scan( /[a-z](?:[a-z_-]*[a-z])?/ )
    words = words.uniq   ## note: do NOT double count (only once per headline)
    words.each do |word|
      freq_words[ word ] ||= 0
      freq_words[ word ] += 1
    end
  end

  freq_words = freq_words.sort do |l,r|
                                  res = r[1]<=>l[1]                ## 1) by count
                                  res = l[0]<=>r[0]  if res == 0   ## 2) by key (a to z)
                                  res
                               end

  # freq_words = freq_words.select { |rec| rec[1] >= 10 && rec[0].size > 1 }
  pp freq_words
  puts "#{freq_words.size} words"


  freq_words = freq_words.select { |rec| whitelist.include?(rec[0]) }
  pp freq_words
  puts "#{freq_words.size} words"

  [freq_words, n]
end

## todo/fix: report non-whitelisted words that are popular (above treshhold!!!!)


## todo/fix: sort whitelist a-z :-).
whitelist = %w(
rails
ruby
rubymine
activerecord
bundler
jruby
hanami
rgsoc
activemodel
passenger
jekyll
conferences
rubygems
rubyconf
rubyinstaller
activesupport
simplecov
puma
truffleruby
docker
discourse
daru
postgresql
dry-struct
dry-types
mri
rbspy
devise
bundle
postgres
dry-validation
enumerable
minitest
yard
openssl
annotate
webgen
enum
actioncable
sinatra
security
mjit
tensorflow
github
cryptography
heroku
rubymotion
actiondispatch
debian
chef
sqlite
webrick
zeitwerk
rubygem
matz
cruby
activestorage
dry-view
fibers
dry-schema
rubocop
dry
rom
ml
css
rack
rackup
record
)


words_2019, n_2019 = headline_wordcount( 2019, whitelist: whitelist )
words_2019 = words_2019.select { |rec| rec[1] >= 3 }   ## ## require min. 3 mentions

words_2020, n_2020 = headline_wordcount( 2020, whitelist: whitelist )
words_2020 = words_2020.select { |rec| rec[1] >= 2 }   ## require min. 2 mentions

barchart( words_2019, title: "Top Words in Headlines 2019", n: n_2019 )
barchart( words_2020, title: "Top Words in Headlines 2020", n: n_2020 )


puts
puts "bye"


