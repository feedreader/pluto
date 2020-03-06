###
#  to run use
#     ruby -I ./lib script/test_readme.rb


require 'barcharts'



data = [
  ['Australia',     3],
  ['Austria',       1],
  ['Canada',        1],
  ['Croatia',       1],
  ['India',         1],
  ['Poland',        2],
  ['Spain',         1],
  ['Switzerland',   1],
  ['Ukraine',       1],
  ['United States', 6],
]

puts barchart( data, title: 'Location', chars: '*' )

puts barchart( data, title: 'Location', chars: '▏▎▍▋▊▉' )



data = [
  ['Webgen',      1],
  ['Jekyll',     12],
  ['WordPress',   3],
  ['Hugo',        1],
  ['Ghost',       2],
  ['Transistor',  1],
  ['Simplecast',  1],
  ['?',          30],
]

puts barchart( data, title: 'Generators', sort: true )

data = [
  ['rails',       13],
  ['ruby',        12],
  ['conferences',  6],
  ['dry',          5],
  ['rom',          4],
  ['ml',           2],
]

puts barchart( data, title: 'Top Words in Headlines 2020', n: 47)
