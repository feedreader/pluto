# Notes


## Todos

- [ ] change `Date#format` to `Date#format_like` or `Date#formatted`  or something else - why? why not?



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
