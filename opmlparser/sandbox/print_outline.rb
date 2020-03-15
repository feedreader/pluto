## render outline to html

require 'opmlparser'

path = "../states.opml.xml"
## path = "../presentation.opml.xml"
h = OPML.load_file( path )

pp h['outline']

=begin
def convert_outline( h, level=1 )
  old_outlines = h['outline']
  outlines = []
  old_outlines.each do |hh|
    if hh.has_key?( 'outline')
      puts " #{level} - #{hh['text']}:"
      puts hh.class.name
      hhh = hh.dup
      hhh.delete('outline')
      puts hhh.class.name
      pp hhh
      outlines << [ :outline,
                    hhh,
                    *convert_outline( hh, level+1 )]
    else  ## terminal / leaf - no children
      puts " #{level} - #{hh['text']}"
      outlines << [:outline, hh.dup]
    end
  end
  outlines
end

puts
puts "outline:"
ary = convert_outline( h )
pp *ary
=end

MLA_STYLE = {
  1 => %w(I II III IV V),
  2 => %w(A B C D E F G H),
  3 => %w(1 2 3 4 5 6 7 8 9 10 11 12),
  4 => %w(a b c d e f g h)
}

pp MLA_STYLE

def mla_style( path )
  ## pp path
  ## I. A. 1. a. i.
  new_path = []
  path.each_with_index do |num, level|
    new_path << MLA_STYLE[level+1][num-1]
  end
  new_path
end

def walk_outline( outlines, level=1, parent_path=[] )
   outlines.each_with_index do |outline,i|
      path = parent_path.dup
      path << (i+1)
      if outline.has_key?( 'outline')
        print '   ' * (level-1)
        ## print "#{mla_style(path)[-1]}."
        print "#{path.join('.')}"
        print " #{outline['text']}\n"
        walk_outline( outline['outline'], level+1, path )
      else  ## terminal / leaf - no children
        print '   ' * (level-1)
        ## print "#{mla_style(path)[-1]}."
        print "#{path.join('.')}"
        print " #{outline['text']}\n"
      end
   end
end

walk_outline( h['outline'] )
