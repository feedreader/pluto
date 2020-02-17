# Notes


## Todos

- [ ] change `Date#format` to `Date#format_like` or `Date#formatted`  or something else - why? why not?
- [ ] add underscore for space-padded e.g. `_2` like `02` for zero-padded - why? why not?


Fully adopt go reference date/time convention? Why? Why not?

I'd say go is pretty on target using an (unambigious) reference date. From the Rosseta stone sample:

     time.Now().Format("2006-01-02"))
     time.Now().Format("Monday, January 2, 2006")

That would be in ruby's date-formatter:

     Time.now.format("YYYY-MM-DD")
     Time.now.format("Monday, January 2, 2006")

Still kind of undecided if it is worth to reserve 1, 01, etc. for months and 2, 02, etc. for days and 3, 03,  etc. for hours and 4, 04, for minutes and 5, 05, etc. for seconds and so on. For now you can write:

    Time.now.format("Friday, February 4, 2020")

and it works too in Ruby's date formatter (but NOT using Golang's time format). In Golang you always MUST use the Monday, January 2, 2006 15:04:05 -7:00 reference date that you can supposedly learn and keep in memory by using the 0-1-2-3-4-5-6-7 trick.  0 = Monday, 1 = January, 2 = Day 2, 3 = Hour 15, 4 = Minute 4, 5 = Second 5, 6 = Year 2006, 7 = Timezone -7:00 (MST). Anyone has any opinions? Pro or contra?


## Go Time Formatter - Reference Time

The reference time used in the layouts is the specific time:

  	Mon Jan 2 15:04:05 MST 2006

which is Unix time 1136239445. Since MST is GMT-0700,
the reference time can be thought of as

  	01/02 03:04:05PM '06 -0700


More:

See source <https://golang.org/src/time/format.go>




## Alternatives

**date_by_example** <https://rubygems.org/gems/date_by_example>, Source: <https://github.com/noelrappin/date_by_example>

``` ruby
class ExampleFormatter
  attr_accessor :reference

  def initialize(reference)
    @reference = reference
    @format_string = nil
  end

  FORMATS = {
    ".000000000" => ".9N",
    "-07:00:00" => "%::z",
    ".000000" => ".%6N",
    "January" => "%B",
    "JANUARY" => "%^B",
    "Monday" => "%A",
    "MONDAY" => "%^A",
    "-07:00" => "%:z",
    "-7000" => "%z",
    "2006" => "%Y",
    ".000" => ".%L",
    "002" => "%j",
    "Jan" => "%b",
    "JAN" => "%^b",
    "Mon" => "%a",
    "MON" => "%^a",
    "MST" => "%Z",
    "15" => "%H",
    "06" => "%y",
    "01" => "%m",
    "02" => "%d",
    "03" => "%I",
    "PM" => "%p",
    "pm" => "%P",
    "04" => "%M",
    "05" => "%S",
    "1" => "%-m",
    "2" => "%-e",
    "3" => "%l"}.freeze

  FORMAT_MATCHER = Regexp.union(FORMATS.keys)

  def format_string
    @format_string ||= reference.gsub(FORMAT_MATCHER, FORMATS)
  end

  def format(date)
    date.strftime(format_string)
  end
end
```


**string_formatted_date** <https://rubygems.org/gems/string_formatted_date>, Source: <https://github.com/TheLarkInn/string_formatted_date>


**date_molder** <https://rubygems.org/gems/date_molder>, Source: <https://github.com/gregolsen/date_molder>

**stamp** <https://rubygems.org/gems/stamp>, Source: <https://github.com/jeremyw/stamp>
