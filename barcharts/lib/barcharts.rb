require 'pp'
require 'date'
require 'time'
require 'json'


# our own code
require 'barcharts/version'   # note: let version always go first



def bar( value, max_value, max_width: 50, chars: '▏▎▍▋▊▉' )
  # ▏   - U+258F  Left one eighth block
  # ▎   - U+258E  Left one quarter block
  # ▍   - U+258D  Left three eighths block
  # ▋   - U+258B  Left five eighths block
  # ▊   - U+258A  Left three quarters block
  # ▉   - U+2589  Left seven eighths block
  #
  ## for unicode block elements see
  ##   https://en.wikipedia.org/wiki/Block_Elements

  width   = (value*max_width).to_f / max_value   ## 50 = max width same as 100%

  buf = chars[-1] * width.floor

  if chars.size > 1    ## check fractional part?
     frac = width - width.floor   # e.g.      12.5405405405405406
                                  #  becomes   0.5405405405405406
     buf += chars[ (frac*chars.size).floor ]   if frac > 0.0
  end

  buf
end


def barchart( data, title:,
                    sort: nil,
                    n: nil,
                    max_width: nil,
                    chars: nil )

  ## note: always convert hash to array
  ##          example:
  ##            { 'one': 1,
  ##              'two': 2 }
  ##  becomes:  [[ 'one', 1],
  ##             [ 'two', 2]]
  data = data.to_a     if data.is_a?( Hash )

  ## convert values to alway be numbers
  ##   e.g. support hash as value e.g. { count: 2 } becomes just 2
  data = data.map do |rec|
                    rec[1] = rec[1][:count]   if rec[1].is_a?( Hash )
                    rec
                  end

  if sort
    data = data.sort_by { |rec| rec[1] }.reverse
  end



  sum       = data.reduce( 0 ) { |sum,rec| sum+rec[1] }
  max_label = data.reduce( 4 ) { |max,rec| rec[0].size > max ? rec[0].size : max }    ## max label length

  n = sum   if n.nil?   ## no n passed in? use (default to) sum

  bar_opts = {  }
  bar_opts[:max_width] = max_width   if max_width
  bar_opts[:chars ]    = chars       if chars
  
  
  buf = "#{title}  (n=#{n})\n"
  buf << "---------------------------------\n"
  data.each do |rec|
    label   = rec[0]
    value   = rec[1]

    percent = value*100 / sum

    buf << "  %-#{max_label}s " % label
    buf << " (%2d%%)" %  percent     if n == sum  ## only print percent if NOT passed in custom n
    buf << " | "
    buf << bar( value, sum, **bar_opts )
    buf << " %d" % value     if value > 0
    buf << "\n"
  end

  buf
end  # method barchart



# say hello
puts Barcharts.banner   if $DEBUG || (defined?($RUBYLIBS_DEBUG) && $RUBYLIBS_DEBUG)
