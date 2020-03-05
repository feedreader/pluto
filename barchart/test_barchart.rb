
require 'pp'


require_relative './barchart'

data = [
  ['two',   2],
  ['one',   1],
  ['three', 3],
  ['five',  5],
  ['four',  4],
]

barchart( data, title: 'Test' )
barchart( data, title: 'Test', sort: true )


data = {
  'two':   2,
  'one':   1,
  'three three': 3,
  'five':  5,
  'four':  4,
}

barchart( data, title: 'Test' )
barchart( data, title: 'Test', sort: true )


data = {
  'two':   { count: 22 },
  'one':   { count: 1 },
  'three': { count: 3 },
  'five':  { count: 55 },
  'four':  { count: 44 },
}

puts "test with count:"
barchart( data, title: 'Test' )
barchart( data, title: 'Test', sort: true )
