require 'pp'
require 'date'
require 'time'
require 'erb'
require 'cgi'
require 'ostruct'
require 'fileutils'



module Enumerable
   class LoopMeta
     def initialize( total )
       @total = total
       @index = 0
     end
     def index=(value) @index=value; end
   end

   def each_with_loop( &blk )
     loop_meta = LoopMeta.new( size )
     each_with_index do |item, index|
        loop_meta.index = index
        blk.call( item, loop_meta )
     end
   end
end



# our own code
require 'html/template/version'    # note: let version always get first



class HtmlTemplate

  attr_reader :text   ## returns converted template text (with "breaking" comments!!!)
  attr_reader :template  ## return "inner" (erb) template object
  attr_reader :errors
  attr_reader :names   ## for debugging - returns all referenced / used names in VAR/IF/UNLESS/LOOP/etc.

  def initialize( text=nil, filename: nil )
    if text.nil?   ## try to read file (by filename)
      text = File.open( filename, 'r:utf-8' ) { |f| f.read }
    end

    ## todo/fix: add filename to ERB too (for better error reporting)
    @text, @errors, @names = convert( text )    ## note: keep a copy of the converted template text

    if @errors.size > 0
      puts "!! ERROR - #{@errors.size} conversion / syntax error(s):"
      pp @errors
      raise   ## todo - find a good Error - StandardError - why? why not?
    end

    @template      = ERB.new( @text, nil, '%<>' )
  end


  VAR_RE = %r{<TMPL_(?<tag>VAR)
                 \s+
                 (?<ident>[a-zA-Z_][a-zA-Z0-9_]*)
                 (\s+
                   (?<escape>ESCAPE)
                      =
                      ("(?<format>HTML|NONE)")
                     | ((?<format>HTML|NONE))   # note: support without quotes too
                 )?
               >}x

  IF_OPEN_RE = %r{(?<open><)TMPL_(?<tag>IF|UNLESS)
                  \s+
                  (?<ident>[a-zA-Z_][a-zA-Z0-9_]*)
                >}x

  IF_CLOSE_RE = %r{(?<close></)TMPL_(?<tag>IF|UNLESS)
                    (\s+
                      (?<ident>[a-zA-Z_][a-zA-Z0-9_]*)
                    )?     # note: allow optional identifier
                  >}x

  ELSE_RE = %r{<TMPL_(?<tag>ELSE)
                 >}x

  LOOP_OPEN_RE = %r{(?<open><)TMPL_(?<tag>LOOP)
                      \s+
                      (?<ident>[a-zA-Z_][a-zA-Z0-9_]*)
                    >}x

  LOOP_CLOSE_RE = %r{(?<close></)TMPL_(?<tag>LOOP)
                      >}x

  CATCH_OPEN_RE = %r{(?<open><)TMPL_(?<unknown>[^>]+?)
                      >}x

  CATCH_CLOSE_RE = %r{(?<close></)TMPL_(?<unknown>[^>]+?)
                      >}x


  ALL_RE = Regexp.union( VAR_RE,
                         IF_OPEN_RE,
                         IF_CLOSE_RE,
                         ELSE_RE,
                         LOOP_OPEN_RE,
                         LOOP_CLOSE_RE,
                         CATCH_OPEN_RE,
                         CATCH_CLOSE_RE )


  def to_recursive_ostruct( o )
    if o.is_a?( Array )
      o.reduce( [] ) do |ary, item|
                       ary << to_recursive_ostruct( item )
                       ary
                     end
    elsif o.is_a?( Hash )
      ## puts 'to_recursive_ostruct (hash):'
      OpenStruct.new( o.reduce( {} ) do |hash, (key, val)|
                                       ## puts "#{key} => #{val}:#{val.class.name}"
                                       hash[key] = to_recursive_ostruct( val )
                                       hash
                                     end )
    else  ## assume regular "primitive" value - pass along as is
      o
    end
  end


  class Names
    def initialize
      @names = Hash.new
    end

    def to_h() @names; end

    def add( scope, ident, tag )
      ## e.g. scope e.g. ['feeds'] or ['feeds','items'] - is a stack / array
      ##      ident e.g.  title                         - is a string
      ##      tag   e.g.  $VAR/$LOOP/$IF/$UNLESS        - is a string
      h = fetch( scope, ident )
      h[ tag ] ||= 0
      h[ tag ] += 1
    end

  private
    def fetch( scope, ident )
      ## fetch name in scoped hierarchy
      ##   if first time than setup new empty hash
      h = @names
      scope.each do |name|
        h = h[name] ||= {}
      end
      h[ ident ] ||= {}
    end
  end  ## class Names


  def convert( text )
    errors = []          # note: reset global errros list
    names  = Names.new   ## keep track of all referenced / used names in VAR/IF/UNLESS/LOOP/etc.

    stack = []

    ## note: convert line-by-line
    ##   allows comments and line no reporting etc.
    buf = String.new('')  ## note: '' required for getting source encoding AND not ASCII-8BIT!!!
    lineno = 0
    text.each_line do |line|
      lineno += 1

      if line.lstrip.start_with?( '#' )    ## or make it tripple ### - why? why not?
         buf << "%#{line.lstrip}"
      elsif line.strip.empty?
         buf << line
      else
         buf << line.gsub( ALL_RE ) do |_|
                  m = $~    ## (global) last match object

                  tag         = m[:tag]
                  tag_open    = m[:open]
                  tag_close   = m[:close]

                  ident       = m[:ident]
                  unknown     = m[:unknown]  # catch all for unknown / unmatched tags

                  escape      = m[:escape]
                  format      = m[:format]

                  ## todo/fix: rename ctx to scope or __ - why? why not?
                  ## note: peek; get top stack item
                  ##   if top level (stack empty)  => nothing
                  ##       otherwise               => channel. or item. etc. (with trailing dot included!)
                  ctx = if stack.empty?
                          ''
                        else
                           ## assume plural ident e.g. channels
                           ##  cut-off last char, that is,
                           ##   the plural s channels => channel
                           ##  note:  ALWAYS downcase (auto-generated) loop iterator/pass name
                           "#{stack[-1][0..-2].downcase}."
                        end

                  code = if tag == 'VAR'
                           names.add( stack, ident, '$VAR' )

                           if escape && format == 'HTML'
                               ## check or use long form e.g. CGI.escapeHTML - why? why not?
                              "<%=h #{ctx}#{ident} %>"
                           else
                              "<%= #{ctx}#{ident} %>"
                           end
                         elsif tag == 'LOOP' && tag_open
                           names.add( stack, ident, '$LOOP' )

                           ## assume plural ident e.g. channels
                           ##  cut-off last char, that is, the plural s channels => channel
                           ##  note:  ALWAYS downcase (auto-generated) loop iterator/pass name
                           it = ident[0..-2].downcase
                           stack.push( ident )
                           "<% #{ctx}#{ident}.each_with_loop do |#{it}, #{it}_loop| %>"
                         elsif tag == 'LOOP' && tag_close
                           stack.pop
                           "<% end %>"
                         elsif tag == 'IF' && tag_open
                           names.add( stack, ident, '$IF' )
                           "<% if #{ctx}#{ident} %>"
                         elsif tag == 'UNLESS' && tag_open
                           names.add( stack, ident, '$UNLESS' )
                           "<% unless #{ctx}#{ident} %>"
                         elsif (tag == 'IF' || tag == 'UNLESS') && tag_close
                           "<% end %>"
                         elsif tag == 'ELSE'
                           "<% else %>"
                         elsif unknown
                            errors <<   if tag_open
                                          "line #{lineno} - unknown open tag: #{unknown}"
                                        else ## assume tag_close
                                          "line #{lineno} - unknown close tag: #{unknown}"
                                        end

                            puts "!! ERROR in line #{lineno} - #{errors[-1]}:"
                            puts line
                            "<%# !!error - #{errors[-1]} %>"
                         else
                           raise ArgumentError  ## unknown tag #{tag}
                         end

                  puts " line #{lineno} - match #{m[0]} replacing with: #{code}"
                  code

                end
        end
      end # each_line
    [buf, errors, names.to_h]
  end # method convert


  class Context < OpenStruct
    ## use a different name - why? why not?
    ##  e.g. to_h, to_hash, vars, locals, assigns, etc.
    def get_binding() binding; end

    ## add builtin helpers / shortcuts
    def h( text ) CGI.escapeHTML( text ); end
  end # class Template::Context

  def render( **kwargs )
    ## todo: use locals / assigns or something instead of **kwargs - why? why not?
    ##        allow/support (extra) locals / assigns - why? why not?
      ## note: Ruby >= 2.5 has ERB#result_with_hash - use later - why? why not?

    kwargs = kwargs.reduce( {} ) do |hash, (key, val)|
                                   ## puts "#{key} => #{val}:#{val.class.name}"
                                   hash[key] = to_recursive_ostruct( val )
                                   hash
                                 end

    ## (auto-)convert array and hash values to ostruct
    ##   for easy dot (.) access
    ##      e.g. student.name instead of student[:name]

    @template.result( Context.new( **kwargs ).get_binding )
  end
end


#####################
## add convenience aliases - why? why not?
HTMLTemplate = HtmlTemplate
module HTML
  Template = HtmlTemplate
end


# say hello
puts HtmlTemplate.banner   if $DEBUG || (defined?($RUBYLIBS_DEBUG) && $RUBYLIBS_DEBUG)

