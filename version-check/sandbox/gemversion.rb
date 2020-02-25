###
## see https://ruby-doc.org/stdlib-2.5.0/libdoc/rubygems/rdoc/Gem/Version.html
##     https://docs.ruby-lang.org/en/2.6.0/Gem/Version.html

require 'pp'

versions_a = ['1.0',
              '1.0.b1',
              '1.0.1',
              '1.0.b.2',
              '1.0.b10',
              '1.0.a.2',
              '0.9',
              '1.0.a10'
             ]

versions_a = versions_a.map { |v| Gem::Version.create( v ) }

pp versions_a
pp versions_a.sort
#=> [Gem::Version.new("0.9"),
#    Gem::Version.new("1.0.a.2"),
#    Gem::Version.new("1.0.a10"),
#    Gem::Version.new("1.0.b1"),
#    Gem::Version.new("1.0.b.2"),
#    Gem::Version.new("1.0.b10"),
#    Gem::Version.new("1.0"),
#    Gem::Version.new("1.0.1")]

pp version_a = versions_a.sort.map { |v| v.to_s }
#=> ["0.9", "1.0.a.2", "1.0.a10", "1.0.b1", "1.0.b.2", "1.0.b10", "1.0", "1.0.1"]


pp Gem::Version.correct?( '1' )           #=> true
pp Gem::Version.correct?( '1.x' )         #=> true
pp Gem::Version.correct?( '1.0' )         #=> true
pp Gem::Version.correct?( '1.0.0' )       #=> true
pp Gem::Version.correct?( '1.0.x' )       #=> true
pp Gem::Version.correct?( '0.9' )         #=> true
pp Gem::Version.correct?( 'x' )           #=> false !!!

pp Gem::Version::ANCHORED_VERSION_PATTERN
#=> /\A
#       \s*
#       ([0-9]+
#          (?>\.[0-9a-zA-Z]+)*
#           (-[0-9A-Za-z-]+
#           (\.[0-9A-Za-z-]+)*
#         )?
#        )?
#       \s*
#    \z/
