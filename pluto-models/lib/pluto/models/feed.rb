# encoding: utf-8


module Pluto
  module Model

class Feed < ActiveRecord::Base
  self.table_name = 'feeds'

  has_many :items
  has_many :subscriptions
  has_many :sites, :through => :subscriptions


  ## todo/fix:
  ##  use a module ref or something; do NOT include all methods - why? why not?
  include TextUtils::HypertextHelper   ## e.g. lets us use strip_tags( ht )


  def self.latest
    # note: order by first non-null datetime field
    #   coalesce - supported by sqlite (yes), postgres (yes)

    # note: if not updated or published use hardcoded 1971-01-01 for now
    ## order( "coalesce(updated,published,'1971-01-01') desc" )
    order( "coalesce(feeds.items_last_updated,'1971-01-01') desc" )
  end

  ##################################
  # attribute reader aliases
  #
  #  todo: check if we can use alias_method :name, :title   - works for non-existing/on-demand-generated method too??

  def name()        title;    end  # alias    for title
  def description() summary;  end  # alias    for summary
  def desc()        summary;  end  # alias(2) for summary
  def subtitle()    summary;  end  # alias(3) for summary
  def link()        url;      end  # alias    for url
  def feed()        feed_url; end  # alias    for feed_url

  def author_name()  author;  end # alias    for author
  def owner_name()   author;  end # alias(2) for author
  def owner()        author;  end # alias(3) for author
  def author_email() email;   end # alias    for email
  def author_email() email;   end # alias(2) for email


  def url?()           read_attribute(:url).present?;       end
  def title?()         read_attribute(:title).present?;     end
  def feed_url?()      read_attribute(:feed_url).present?;  end

  def url()      read_attribute_w_fallbacks( :url,      :auto_url );      end
  def title()    read_attribute_w_fallbacks( :title,    :auto_title );    end
  def feed_url() read_attribute_w_fallbacks( :feed_url, :auto_feed_url ); end

  def summary?()      read_attribute(:summary).present?;  end


  def updated?()    read_attribute(:updated).present?;    end
  def published?()  read_attribute(:published).present?;  end

  def updated
    ## todo/fix: use a new name - do NOT squeeze convenience lookup into existing
    #    db backed attribute
    read_attribute_w_fallbacks( :updated, :published )
  end

  def published
    ## todo/fix: use a new name - do NOT squeeze convenience lookup into existing
    #    db backed attribute
    read_attribute_w_fallbacks( :published, :updated )
  end


  def debug=(value)  @debug = value;   end
  def debug?()       @debug || false;  end


  def deep_update_from_struct!( data )

    ######
    ## check for filters (includes/excludes) if present
    ##  for now just check for includes
    ##
    if includes.present?
      includesFilter = FeedFilter::IncludeFilters.new( includes )
    else
      includesFilter = nil
    end

    data.items.each do |item|
      if includesFilter && includesFilter.match_item?( item ) == false
        puts "** SKIPPING | #{item.title}"
        puts "  no include terms match: #{includes}"
        next   ## skip to next item
      end

      item_rec = Item.find_by_guid( item.guid )
      if item_rec.nil?
        item_rec  = Item.new
        puts "** NEW | #{item.title}"
      else
        ## todo: check if any attribs changed
        puts "UPDATE | #{item.title}"
      end

      item_rec.debug = debug? ? true : false  # pass along debug flag

      item_rec.feed_id = id        # feed_rec.id - add feed_id fk_ref
      item_rec.fetched = fetched   # feed_rec.fetched

      item_rec.update_from_struct!( item )

    end  # each item


    #  update  cached value last published for item
    ##  todo/check: force reload of items - why? why not??
    last_item_rec = items.latest.limit(1).first  # note limit(1) will return relation/arrar - use first to get first element or nil from ary
    if last_item_rec.present?
      if last_item_rec.updated?
        self.items_last_updated = last_item_rec.updated
        ## save!  ## note: will get save w/ update_from_struct!  - why? why not??
      else # try published
        self.items_last_updated = last_item_rec.published
        ## save!  ## note: will get save w/ update_from_struct!  - why? why not??
      end
    end

    update_from_struct!( data )
  end # method deep_update_from_struct!


  def update_from_struct!( data )

##
# todo:
##  strip all tags from summary (subtitle)
##  limit to 255 chars
## e.g. summary (subtitle) such as this exist
##  This is a low-traffic announce-only list for people interested
##  in hearing news about Polymer (<a href="http://polymer-project.org">http://polymer-project.org</a>).
## The higher-traffic mailing list for all kinds of discussion is
##  <a href="https://groups.google.com/group/polymer-dev">https://groups.google.com/group/polymer-dev</a>

    feed_attribs = {
        format:       data.format,
        updated:      data.updated,
        published:    data.published,
        summary:      data.summary,
        generator:    data.generator.to_s,    ## note: use single-line/string generator stringified -- might return null (if no data)
        ### todo/fix: add/use
        # auto_title:     ???,
        # auto_url:       ???,
        # auto_feed_url:  ???,
      }

    if debug?
        ## puts "*** dump feed_attribs:"
        ## pp feed_attribs
        puts "*** dump feed_attribs w/ class types:"
        feed_attribs.each do |key,value|
          puts "  #{key}: >#{value}< : #{value.class.name}"
        end
    end

    update_attributes!( feed_attribs )
  end

end  # class Feed


  end # module Model
end # module Pluto
