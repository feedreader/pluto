module Pluto


class Fetcher

  def initialize( logger, opts )
    @logger  = logger
    @opts    = opts
    
    @config = YAML.load_file( 'pluto.yml')
    
    pp @config
    
    setup_db
  end

  attr_reader :logger, :opts

  def setup_db
    
    db_config = {
      :adapter  => 'sqlite3',
      :database => './pluto.sqlite'
    }
    
    ActiveRecord::Base.establish_connection( db_config )
    
    unless Feed.table_exists?
      ActiveRecord::Schema.define do
        create_table :feeds do |t|
          t.string  :title         # todo: add null => false
          t.string  :url
          t.string  :feed_url
          t.string  :key  # import/export key
          t.timestamps
        end
        
        create_table :items do |t|
          t.string   :title
          t.string   :url
          t.string   :guid
          t.text     :content
          t.datetime :published_at
          t.references :feed    # , :null => false
          t.timestamps
        end
      end
    end
  end
  
  
  def run
    
    logger = Logger.new( STDOUT )
    worker = ::Fetcher::Worker.new( logger )

=begin    
    @config[ 'feeds' ].each do |feed_key|
      
      feed_hash = @config[ feed_key ]
      feed = feed_hash[ 'feed' ]
      
      puts "Fetch feed >#{feed}<..."

      worker.copy( feed, "./#{feed_key}.xml" )      
    end
=end

    puts "*** RSS::VERSION #{RSS::VERSION}"
    
    pp RSS::AVAILABLE_PARSERS

    @config[ 'feeds' ].each do |feed_key|
      
      feed_hash = @config[ feed_key ]
      
      puts "Parsing feed >#{feed_key}<..."

      xml = File.read( "./#{feed_key}.xml" )

      parser = RSS::Parser.new( xml )
      parser.do_validate = false
      parser.ignore_unknown_element = true
      feed = parser.parse
      
      puts "feed.class=#{feed.class.name}"

      puts "==  #{feed.channel.title} =="

      feed.items.each do |item|
        puts "- #{item.title}"
        puts "  link (#{item.link})"
        puts "  guid (#{item.guid.content})"
        puts "  pubDate (#{item.pubDate}) : #{item.pubDate.class.name}"
        puts
        
        rec = Item.find_by_guid( item.guid.content )
        if rec.nil?
          rec = Item.new
          rec.guid = item.guid.content
        end
        
        item_attribs = {
          :title        => item.title,
          :url          => item.link,
          :published_at => item.pubDate
        }
        
        rec.update_attributes!( item_attribs )
        
        # puts "*** dump item:"
        # pp item
        
       end
    end # each feed

  end # method run

end # class Fetcher

end # module Pluto
