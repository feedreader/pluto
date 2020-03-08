require 'pp'
require 'rexml/Document'


##
## see http://dev.opml.org/spec2.html
##   for examples


module OPML

def self.load( xml )
  parse( xml, outlinify: false )
end

def self.load_file( path )
  xml = File.open( path, 'r:utf-8' ) { |f| f.read }
  load( xml )
end


#####################################
### helper methods
## (internal) helper method
def self.parse( xml, outlinify: false )
  opml = REXML::Document.new( xml )

  puts "head:"
  meta    = {}
  opml.elements['opml/head'].elements.each do |el|
    meta[ el.name ] = el.text
  end

  puts "body:"
  outline = []
  parse_outline( outline, opml.elements['opml/body'], outlinify: outlinify )

  if outlinify
    Outline.new( { 'meta'    => Outline::Meta.new( meta ),
                   'outline' => outline } )
  else
    { 'meta'    => meta,
      'outline' => outline }
  end
end

def self.parse_outline( outlines, node, outlinify:)
  node.elements.each( 'outline' ) do |el|
    outline    = {}

    el.attributes.each do |attr|
      outline[ attr[0] ] =  attr[1]
    end

    if el.elements.size > 0
      children = []
      parse_outline( children, el, outlinify: outlinify )
      outline[ 'outline' ] = children
    end

    ## todo/fix: find a better name - use easyaccess or something?
    ##  outlinify - wrap hash for easy access in Outline class
    outlines <<   if outlinify   ## wrap in Outline
                    Outline.new( outline )
                  else
                    outline
                  end
  end
end


class Outline
  def self.parse( xml )
    Parser.new( xml ).parse
  end
  def self.read( path )
    xml = File.open( path, 'r:utf-8' ) { |f| f.read }
    parse( xml )
  end

  class << self   ## add aliases
    alias_method :load,      :parse   ## todo/check: add load alias - why? why not?
    alias_method :load_file, :read    ## todo/check: add load_file alias - why? why not?
  end


  class Parser
    def initialize( xml )
      @xml = xml
    end

    def parse
      OPML.parse( @xml, outlinify: true )
    end
  end  # class Parser


  class Meta
    def initialize( h )
      @h = h
    end

    def [](key) @h[key]; end
  end # class Meta



  def initialize( h )
   @h = h
  end

  def [](index)
    if index.is_a?(Integer)
      h = @h['outline'][index]
      h = Outline.new( h )  if h.is_a?(Hash)  ## allow "on-demand" use/wrapping too - why? why not?
      h
    else  ## assume index is a text key
      @h[ index ]
    end
  end

  ## array delegates for outline children
  ##   todo/fix: check if outline can be nil? !!!!
  def size() @h['outline'].size; end
  alias_method :length, :size

  def each( &blk ) @h['outline'].each( &blk ); end


  def text()   @h['text'];   end
  def xmlUrl() @h['xmlUrl']; end
  alias_method :xml_url, :xmlUrl

  def url()    @h['url']; end

  def meta()  @h['meta']; end
end # class Outline
end # module OPML


## add some convenience shortcuts
Outline = OPML::Outline
