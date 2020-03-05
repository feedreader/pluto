# barchart gem - print barcharts in your terminal in ascii or with unicode block elements

* home  :: [github.com/feedreader/pluto](https://github.com/feedreader/pluto)
* bugs  :: [github.com/feedreader/pluto/issues](https://github.com/feedreader/pluto/issues)
* gem   :: [rubygems.org/gems/barchart](https://rubygems.org/gems/barchart)
* rdoc  :: [rubydoc.info/gems/barchart](http://rubydoc.info/gems/barchart)
* forum :: [groups.google.com/group/wwwmake](http://groups.google.com/group/wwwmake)


## Usage

Use the `barchart` method to print barcharts.
Let's use the
"Q: Where do Rubyists come from / What are the top countries for blogs?"
example from the Planet Ruby page:

``` ruby
require 'barchart'

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

# -or-

data = {
  'Australia':     3,
  'Austria':       1,
  'Canada':        1,
  'Croatia':       1,
  'India':         1,
  'Poland':        2,
  'Spain':         1,
  'Switzerland':   1,
  'Ukraine':       1,
  'United States': 6,
}

p barchart( data, title: 'Location', chars: '*' )
```

Resulting in:

```
Location  (n=18)
---------------------------------
  Australia      (16%) | ******** 3
  Austria        ( 5%) | ** 1
  Canada         ( 5%) | ** 1
  Croatia        ( 5%) | ** 1
  India          ( 5%) | ** 1
  Poland         (11%) | ***** 2
  Spain          ( 5%) | ** 1
  Switzerland    ( 5%) | ** 1
  Ukraine        ( 5%) | ** 1
  United States  (33%) | **************** 6
```

or using Unicode block elements:

``` ruby
p barchart( data, title: 'Location', chars: '▏▎▍▋▊▉' )
```

Resulting in:

```
Location  (n=18)
---------------------------------
  Australia      (16%) | ▉▉▉▉▉▉▉▉▍ 3
  Austria        ( 5%) | ▉▉▊ 1
  Canada         ( 5%) | ▉▉▊ 1
  Croatia        ( 5%) | ▉▉▊ 1
  India          ( 5%) | ▉▉▊ 1
  Poland         (11%) | ▉▉▉▉▉▋ 2
  Spain          ( 5%) | ▉▉▊ 1
  Switzerland    ( 5%) | ▉▉▊ 1
  Ukraine        ( 5%) | ▉▉▊ 1
  United States  (33%) | ▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▊ 6
```


Aside: What are Unicode block elements?

Unicode among other block elements defines:

- `▏`   - U+258F - Left one eighth block
- `▎`   - U+258E - Left one quarter block
- `▍`   - U+258D - Left three eighths block
- `▋`   - U+258B - Left five eighths block
- `▊`   - U+258A - Left three quarters block
- `▉`   - U+2589 - Left seven eighths block

See [Block Elements @ Wikipedia](https://en.wikipedia.org/wiki/Block_Elements) for more.



### Barchart Options - `sort: true|false`, `n: <sample size>`

Pass in `sort: true` to reverse sort the dataset (highest values first).
Let's use the
"Q: What (web site) publishing tools are in use?" example:

``` ruby
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

p barchart( data, title: 'Generators', sort: true )
```

Resulting in:

```
Generators  (n=51)
---------------------------------
  ?           (58%) | ▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▍ 30
  Jekyll      (23%) | ▉▉▉▉▉▉▉▉▉▉▉▊ 12
  WordPress   ( 5%) | ▉▉▉ 3
  Ghost       ( 3%) | ▉▉ 2
  Hugo        ( 1%) | ▉ 1
  Transistor  ( 1%) | ▉ 1
  Simplecast  ( 1%) | ▉ 1
  Webgen      ( 1%) | ▉ 1
```


Pass in `n: <sample size>` to use a "custom" sample size
AND to turn off the auto-calculation of the
usage percentage.
Let's use the
"Q: What are the top topics / words in headlines?" example:

``` ruby
data = [
  ['rails',       13],
  ['ruby',        12],
  ['conferences',  6],
  ['dry',          5],
  ['rom',          4],
  ['ml',           2],
]

p barchart( data, title: 'Top Words in Headlines 2020', n: 47)
```

resulting in:

```
Top Words in Headlines 2020  (n=47)
---------------------------------
  rails        | ▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▍ 13
  ruby         | ▉▉▉▉▉▉▉▉▉▉▉▉▉▉▎ 12
  conferences  | ▉▉▉▉▉▉▉▏ 6
  dry          | ▉▉▉▉▉▉ 5
  rom          | ▉▉▉▉▊ 4
  ml           | ▉▉▍ 2
```


That's all for now.



## License

The `barchart` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.

## Questions? Comments?

Send them along to the [wwwmake Forum/Mailing List](http://groups.google.com/group/wwwmake).
Thanks!
