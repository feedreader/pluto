require 'pp'
require 'date'
require 'time'
require 'erb'
require 'cgi'
require 'ostruct'
require 'fileutils'


# our own code
require 'html/template/version'    # note: let version always get first



class HtmlTemplate

  attr_reader :text   ## returns converted template text (with "breaking" comments!!!)

  def initialize( text )
    @text     = convert( text )    ## note: keep a copy of the converted template text
    @template = ERB.new( strip_comments( @text ) )
  end


  VAR_RE = %r{<TMPL_(?<tag>VAR)
                 \s
                 (?<ident>[a-zA-Z_0-9]+)
               >}x

  IF_OPEN_RE = %r{(?<open><)TMPL_(?<tag>IF)
                  \s
                  (?<ident>[a-zA-Z_0-9]+)
                >}x

  IF_CLOSE_RE = %r{(?<close></)TMPL_(?<tag>IF)
                  >}x

  LOOP_OPEN_RE = %r{(?<open><)TMPL_(?<tag>LOOP)
                      \s
                      (?<ident>[a-zA-Z_0-9]+)
                    >}x

  LOOP_CLOSE_RE = %r{(?<close></)TMPL_(?<tag>LOOP)
                      >}x

  CATCH_OPEN_RE = %r{(?<open><)TMPL_(?<unknown>[^>]+?)
                      >}x


  ALL_RE = Regexp.union( VAR_RE,
                         IF_OPEN_RE,
                         IF_CLOSE_RE,
                         LOOP_OPEN_RE,
                         LOOP_CLOSE_RE,
                         CATCH_OPEN_RE )


  def strip_comments( text )
     ## strip/remove comments lines starting with #
     buf = String.new('') ## note: '' required for getting source encoding AND not ASCII-8BIT!!!
     text.each_line do |line|
        next if line.lstrip.start_with?( '#' )
        buf << line
     end
     buf
  end

  def convert( text )
    stack = []

    ## note: convert line-by-line
    ##   allows comments and line no reporting etc.
    buf = String.new('')  ## note: '' required for getting source encoding AND not ASCII-8BIT!!!
    lineno = 0
    text.each_line do |line|
      lineno += 1

      if line.lstrip.start_with?( '#' )    ## or make it tripple ### - why? why not?
         buf << line    ## pass along as is for now!!
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

                  ## todo/fix: rename ctx to scope or __ - why? why not?
                  ## note: peek; get top stack item
                  ##   if top level (stack empty)  => nothing
                  ##       otherwise               => channel. or item. etc. (with trailing dot included!)
                  ctx = stack.empty? ? '' : "#{stack[-1]}."

                  code = if tag == 'VAR'
                           "<%= #{ctx}#{ident} %>"
                         elsif tag == 'LOOP' && tag_open
                           ## assume plural ident e.g. channels
                           ##  cut-off last char, that is, the plural s channels => channel
                           ##  note:  ALWAYS downcase (auto-generated) loop iterator/pass name
                           it = ident[0..-2].downcase
                           stack.push( it )
                           "<% #{ctx}#{ident}.each do |#{it}| %>"
                         elsif tag == 'LOOP' && tag_close
                           stack.pop
                           "<% end %>"
                         elsif tag == 'IF' && tag_open
                           "<% if #{ctx}#{ident} %>"
                         elsif tag == 'IF' && tag_close
                           "<% end %>"
                         elsif unknown && tag_open
                          puts "!! ERROR"
                           "<%# !!error - unknown open tag: #{unknown} %>"
                         else
                           raise ArgumentError  ## unknown tag #{tag}
                         end

                  puts " line #{lineno} - match #{m[0]} replacing with: #{code}"
                  code

                end
        end
      end # each_line
    buf
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

