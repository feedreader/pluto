
require 'pp'


require_relative './barchart'



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

barchart( data, title: 'Location', chars: '*' )

barchart( data, title: 'Location', chars: '▏▎▍▋▊▉' )



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

barchart( data, title: 'Generators', sort: true )

data = [
  ['rails',       13],
  ['ruby',        12],
  ['conferences',  6],
  ['dry',          5],
  ['rom',          4],
  ['ml',           2],
]

barchart( data, title: 'Top Words in Headlines 2020', n: 47)
