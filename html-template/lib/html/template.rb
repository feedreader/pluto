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
    end

    def index=(value)
      @index   = value;
      @counter = @index+1

      ## assume first item (index 0/counter 1) is odd - why? why not?
      ## 0 % 2  => 0   (odd)  -- first
      ## 1 % 2  => 1   (even) -- second
      ## 2 % 2  => 0
      ## 3 % 2  => 1
      ## etc.
      @odd     = (@index % 2) == 0
      @even    = !@odd

      if @index == 0
          @first = true
          @inner = false
          @outer = true
          @last  = (@total-1) == 0
      elsif @index == (@total-1)
          @first = false
          @inner = false
          @outer = true
          @last  = true
      else
          @first = false
          @inner = true
          @outer = false
          @last  = false
      end
    end

    attr_reader :index
    attr_reader :counter
    attr_reader :odd
    attr_reader :even
    attr_reader :first
    attr_reader :inner
    attr_reader :outer
    attr_reader :last

    alias_method :odd?,   :odd
    alias_method :even?,  :even
    alias_method :first?, :first
    alias_method :inner?, :inner
    alias_method :outer?, :outer
    alias_method :last?,  :last

    alias_method :__index__,   :index
    alias_method :__counter__, :counter
    alias_method :__odd__,     :odd
    alias_method :__even__,    :even
    alias_method :__first__,   :first
    alias_method :__inner__,   :inner
    alias_method :__outer__,   :outer
    alias_method :__last__,    :last

    alias_method :__INDEX__,   :index
    alias_method :__COUNTER__, :counter
    alias_method :__ODD__,     :odd
    alias_method :__EVEN__,    :even
    alias_method :__FIRST__,   :first
    alias_method :__INNER__,   :inner
    alias_method :__OUTER__,   :outer
    alias_method :__LAST__,    :last
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

  class Configuration
    def debug=(value)      @debug = value;   end
    def debug?()           @debug || false;  end

    def strict=(value)     @strict = value;  end
    def strict?()          @strict || true;  end

    def loop_vars=(value)  @loop_vars = value; end
    def loop_vars?()       @loop_vars || true; end
  end # class Configuration

  ## lets you use
  ##   HtmlTemplate.configure do |config|
  ##      config.debug        = true
  ##      config.strict       = true
  ##   end

  def self.configure
    yield( config )
  end

  def self.config
    @config ||= Configuration.new
  end


  attr_reader :text   ## returns converted template text (with "breaking" comments!!!)
  attr_reader :template  ## return "inner" (erb) template object
  attr_reader :errors
  attr_reader :names   ## for debugging - returns all referenced / used names in VAR/IF/UNLESS/LOOP/etc.

  ## config convenience (shortcut) helpers
  def config() self.class.config; end
  def debug?() config.debug?;     end

  def strict?()    @strict;    end
  def loop_vars?() @loop_vars; end

  def initialize( text=nil, filename: nil, strict: config.strict?, loop_vars: config.loop_vars? )
    if text.nil?   ## try to read file (by filename)
      text = File.open( filename, 'r:utf-8' ) { |f| f.read }
    end

    ## options
    @strict    = strict
    @loop_vars = loop_vars

    ## todo/fix: add filename to ERB too (for better error reporting)
    @text, @errors, @names = convert( text )    ## note: keep a copy of the converted template text

    if @errors.size > 0
      puts "!! ERROR - #{@errors.size} conversion / syntax error(s):"
      pp @errors

      raise     if strict? ## todo - find a good Error - StandardError - why? why not?
    end

    @template      = ERB.new( @text, nil, '%<>' )
  end



  IDENT   = '[a-zA-Z_][a-zA-Z0-9_]*'
  ESCAPES = 'HTML|NONE'

  VAR_RE = %r{<TMPL_(?<tag>VAR)
                 \s+
                 (?<ident>#{IDENT})
                 (\s+
                   (?<escape>ESCAPE)
                      \s*=\s*(
                          (?<q>['"])(?<format>#{ESCAPES})\k<q>  # note: allow single or double enclosing quote (but MUST match)
                        |  (?<format>#{ESCAPES})              # note: support without quotes too
                       )
                 )?
               >}x

  IF_OPEN_RE = %r{(?<open><)TMPL_(?<tag>IF|UNLESS)
                  \s+
                  (?<ident>#{IDENT})
                >}x

  IF_CLOSE_RE = %r{(?<close></)TMPL_(?<tag>IF|UNLESS)
                    (\s+
                      (?<ident>#{IDENT})
                    )?     # note: allow optional identifier
                  >}x

  ELSE_RE = %r{<TMPL_(?<tag>ELSE)
                 >}x

  LOOP_OPEN_RE = %r{(?<open><)TMPL_(?<tag>LOOP)
                      \s+
                      (?<ident>#{IDENT})
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


  def ident_to_loop_it( ident )  # make loop iterator (e.g. Channels => channel and so on)
     ## assume plural ident e.g. channels
     ##  cut-off last char, that is,
     ##   the plural s channels => channel
     ##  note:  ALWAYS downcase (auto-generated) loop iterator/pass name
     ident[0..-2].downcase
  end


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
                           ## check for special loop variables
                           if loop_vars? &&
                              ['__INDEX__',
                               '__COUNTER__',
                               '__INDEX__',
                               '__COUNTER__',
                               '__ODD__',
                               '__EVEN__',
                               '__FIRST__',
                               '__INNER__',
                               '__OUTER__',
                               '__LAST__'
                              ].include?( ident )
                             "#{ident_to_loop_it( stack[-1] )}_loop."
                           else
                           ## assume plural ident e.g. channels
                           ##  cut-off last char, that is,
                           ##   the plural s channels => channel
                           ##  note:  ALWAYS downcase (auto-generated) loop iterator/pass name
                             "#{ident_to_loop_it( stack[-1] )}."
                           end
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
                           it = ident_to_loop_it( ident )
                           stack.push( ident )
                           if loop_vars?
                             "<% #{ctx}#{ident}.each_with_loop do |#{it}, #{it}_loop| %>"
                           else
                             "<% #{ctx}#{ident}.each do |#{it}| %>"
                           end
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

                  puts " line #{lineno} - match #{m[0]} replacing with: #{code}"  if debug?
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

