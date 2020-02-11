## minitest setup
require 'minitest/autorun'

## our own code
require 'html/template'

HtmlTemplate.config.debug = true


########
## add some "global" helpers
require 'rexml/document'

def prettify_xml( xml )
    d = REXML::Document.new( xml )

    formatter = REXML::Formatters::Pretty.new( 2 )  # indent=2
    formatter.compact = true # This is the magic line that does what you need!
    pretty_xml = formatter.write( d.root, "" )  # todo/checl: what's 2nd arg used for ??
    pretty_xml
end

