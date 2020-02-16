# date-formatter - date formatter by example; auto-builds the strftime format string from an example date


* home  :: [github.com/feedreader/pluto](https://github.com/feedreader/pluto)
* bugs  :: [github.com/feedreader/pluto/issues](https://github.com/feedreader/pluto/issues)
* gem   :: [rubygems.org/gems/date-formatter](https://rubygems.org/gems/date-formatter)
* rdoc  :: [rubydoc.info/gems/date-formatter](http://rubydoc.info/gems/date-formatter)
* forum :: [groups.google.com/group/wwwmake](http://groups.google.com/group/wwwmake)



## Usage

The date by example lets you format dates e.g. "January 02, 2006" 
using an example as a format string e.g "January 02, 2006" instead of the classic strftime format specifier e.g. "%B %d, %Y". The date by example adds:

- `String#to_strfime`
- `Date#format`
- `Time#format`
- `DateTime#format`
- `NilClass#format`

to the built-in classes.


### The `String#to_strftime` Method

```ruby
class String
  def to_strftime() DateByExample.to_strftime( self ); end
end
```

The new `String#to_strftime` method auto-builds the `strftime` format string
from an example date:

``` ruby
require 'date/formatter'

p 'January 02, 2006'.to_strftime          #=> "%B %d, %Y"
p 'Mon, Jan 02'.to_strftime               #=> "%a, %b %d"
p '2 Jan 2006'.to_strftime                #=> "%-d %b %Y"
p 'Monday, January 2, 2006'.to_strftime   #=> "%A, %B %-d, %Y"

p 'Mon, Jan 02 3:00'.to_strftime          #=> "%a, %b %d %-H:%M"
p '2 Mon 2006 03:00'.to_strftime          #=> "%-d %b %Y %H:%M"
```


### The `Date#format` Method

``` ruby
class Date
  def format( spec ) self.strftime( spec.to_strftime ); end
end
```

The new `Date#format` method formats the date like the passed in example:

``` ruby
date = Date.today   ## test run on 2020-02-09

p date.format( 'January 02, 2006' )         #=> "February 09, 2020"
p date.format( 'Mon, Jan 02' )              #=> "Sun, Feb 09"
p date.format( '2 Jan 2006' )               #=> "9 Feb 2020"
p date.format( 'Monday, January 2, 2006' )  #=> "Sunday, February 9, 2020"
```



### The `Time#format` Method

``` ruby
class Time
  def format( spec ) self.strftime( spec.to_strftime ); end
end
```

The new `Time#format` method formats the time like the passed in example:

``` ruby
time = Time.now     ## test run on 2020-02-09 00:00

p time.format( 'January 02, 2006' )         #=> "February 09, 2020"
p time.format( 'Mon, Jan 02' )              #=> "Sun, Feb 09"
p time.format( '2 Jan 2006' )               #=> "9 Feb 2020"
p time.format( 'Monday, January 2, 2006' )  #=> "Sunday, February 9, 2020"

p time.format( 'Mon, Jan 02 3:00' )         #=> "Sun, Feb 09 0:00"
p time.format( '2 Mon 2006 03:00' )         #=> "9 Sun 2020 00:00"
```


### The `NilClass#format` Method

``` ruby
class NilClass
  def format( spec ) ''; end
end
```

For convenience the new `NilClass#format` will catch format calls on `nil`  
and NOT crash but return an empty string
following the `NilClass#to_s` example:

``` ruby
p nil.format( 'January 02, 2006' )         #=> ""
p nil.to_s                                 #=> ""
```


## License

![](https://publicdomainworks.github.io/buttons/zero88x31.png)

The `date-formatter` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.

## Questions? Comments?

Send them along to the [wwwmake Forum/Mailing List](http://groups.google.com/group/wwwmake).
Thanks!
