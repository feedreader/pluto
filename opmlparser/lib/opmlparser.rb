require 'pp'
require 'date'
require 'time'
require 'rexml/document'


# our own code
require 'opmlparser/version'   # note: let version always go first



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

  ### parse head
  meta    = {}
  opml.elements['opml/head'].elements.each do |el|
    meta[ el.name ] = el.text
  end

  ## parse body
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

    def title()        @h['title']; end
    def dateCreated()  @h['dateCreated' ]; end
    alias_method :date_created, :dateCreated
    alias_method :created,      :dateCreated

    def dateModified() @h['dateModified']; end
    alias_method :date_modified, :dateModified
    alias_method :modified,      :dateModified

    def ownerName() @h['ownerName']; end
    alias_method :owner_name, :ownerName

    def ownerEmail() @h['ownerEmail']; end
    alias_method :owner_email, :ownerEmail

    def ownerId() @h['ownerId']; end
    alias_method :owner_id, :ownerId
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


  def text()         @h['text'];   end
  def xmlUrl()       @h['xmlUrl']; end
  alias_method :xml_url, :xmlUrl

  def url()          @h['url']; end
  def htmlUrl()      @h['htmlUrl']; end
  alias_method :html_url, :htmlUrl

  def created()      @h['created']; end
  def title()        @h['title']; end
  def type()         @h['type']; end
  def category()     @h['category']; end
  def description()  @h['description']; end
  def language()     @h['language']; end
  def version()      @h['version']; end

  def meta()  @h['meta']; end
end # class Outline
end # module OPML


## add some convenience shortcuts
Outline = OPML::Outline



# say hello
puts OPML.banner   if $DEBUG || (defined?($RUBYLIBS_DEBUG) && $RUBYLIBS_DEBUG)
