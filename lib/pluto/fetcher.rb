module Pluto


class Fetcher

  include LogUtils::Logging

  def initialize
    @worker  = ::Fetcher::Worker.new
  end

  def debug=(value)  @debug = value;   end
  def debug?()       @debug || false;  end


  def feed_by_rec( feed_rec )
    feed_url = feed_rec.feed_url
    feed_key = feed_rec.key
    
    feed_xml = fetch_feed( feed_url )

    logger.debug "feed_xml:"
    logger.debug feed_xml[ 0..300 ] # get first 300 chars

    #  if opts.verbose?  # also write a copy to disk
    if debug?
      logger.debug "saving feed to >./#{feed_key}.xml<..."
      File.open( "./#{feed_key}.xml", 'w' ) do |f|
        f.write( feed_xml )
      end
    end
      
    puts "Before parsing feed >#{feed_key}<..."

    ### move to feedutils
    ### logger.debug "using stdlib RSS::VERSION #{RSS::VERSION}"

    ## fix/todo: check for feed.nil?   -> error parsing!!!
    #    or throw exception
    feed = FeedUtils::Parser.parse( feed_xml )
  end


  def fetch_feed( url )
    ### fix: use worker.get( url )  # check http response code etc.
    
    xml = @worker.read( url )

    ###
    # NB: Net::HTTP will NOT set encoding UTF-8 etc.
    # will mostly be ASCII
    # - try to change encoding to UTF-8 ourselves
    logger.debug "xml.encoding.name (before): #{xml.encoding.name}"

    #####
    # NB: ASCII-8BIT == BINARY == Encoding Unknown; Raw Bytes Here

    ## NB:
    # for now "hardcoded" to utf8 - what else can we do?
    # - note: force_encoding will NOT change the chars only change the assumed encoding w/o translation
    xml = xml.force_encoding( Encoding::UTF_8 )
    logger.debug "xml.encoding.name (after): #{xml.encoding.name}"      

    xml
  end
  
end # class Fetcher

end # module Pluto
