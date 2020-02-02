

require 'iniparser'
require 'fetcher'
require 'nokogiri'
require 'feedparser'


path = '../test/ruby.ini'
# path = '../test/opendata.ini'



h = INI.load_file( path )
pp h


LogUtils::Logger.root.level = :info  # :debug 
worker = Fetcher::Worker.new


###
## todo/fix:
##  check for redirect and report number of redirect and locations!!!!
##  e.g.  status code, location, count - why? why not?
##
##   abort("#{error}\nTry using `#{res.headers['location']}` instead") 
##      if res.status.to_i.between?(300, 399) && res.headers.has_key?('location')
##
## [debug] GET /en/news uri=http://www.ruby-lang.org/en/news, redirect_limit=5
## [debug] 301 Moved Permanently location=/en/news/
## [debug] url relative; try to make it absolute
## [debug] GET /en/news/ uri=http://www.ruby-lang.org/en/news/, redirect_limit=4
## [debug] 200 OK
##
## [debug] GET /feed/atom.xml uri=http://weblog.rubyonrails.org/feed/atom.xml, redirect_limit=5
## [debug] 301 Moved Permanently location=https://weblog.rubyonrails.org/feed/atom.xml
## [debug] GET /feed/atom.xml uri=https://weblog.rubyonrails.org/feed/atom.xml, redirect_limit=4
## [debug] 200 OK 


## todo/fix:
##   try adding color?  200 OK  in green and errors in RED!!!
##    and dim color for xml snippet??



h.each do |feed_key, props|
  if props.is_a?(Hash)
      puts
      puts "::::::::::::::::::::::::::::::::::::::"
      puts ":: #{feed_key} => #{props['title']}"
 
      ['link', 'feed'].each do |key|
        if props.has_key?( key ) 
            url = props[ key ] 
 
            res = worker.get( url ) 
            if res.code.to_i == 200
              print "  #{res.code} #{res.message}  "
            else
              print "  !!! "
              print " #{res.code} #{res.message} - "
            end
            print " #{key} => #{url}:\n"
            puts  "    content-type: #{res['content-type']}" +    
                  " | content-length: #{res['content-length']}"
            puts  "          server: #{res['server']}"
 
            if key == 'feed' && res.code.to_i == 200
                text = res.body
                head = text.lstrip[0..400]
                puts "---"
                puts head    ## print first 400 chars

                ## always assume xml for now (check for json later)
                xml_err = Nokogiri::XML( text ).errors
                if xml_err.size > 0
                   puts "  !!! Invalid XML syntax:"
                   pp xml_err
                end 

                ### check feedparser
                parser = FeedParser::Parser.new( text )
                feed = parser.parse_xml

                puts "---"
                puts  "     format: #{feed.format}"
                puts  "  generator: #{feed.generator.to_s ? feed.generator : '?'}"
                print "    updated: #{feed.updated}"
                print " - #{(Date.today.jd - feed.updated.to_date.jd)} days ago" if feed.updated?
                print "\n"  
                puts  "      items: #{feed.items.size}"
            end 
        else
            puts "  !!! #{key} missing"
        end
      end      
    end
  end

