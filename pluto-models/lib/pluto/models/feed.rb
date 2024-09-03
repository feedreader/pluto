# encoding: utf-8


module Pluto
  module Model


class Feed < ActiveRecord::Base

## logging w/ ActiveRecord
##   todo/check: check if logger instance method is present by default?
##     only class method present?
##   what's the best way to add logging to activerecord (use "builtin" machinery??)


  def debug?()  Pluto.config.debug?;  end



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

    # note: if not updated or published use hardcoded 1970-01-01 for now
    ## was: order( "coalesce(updated,published,'1970-01-01') desc" )
    order( Arel.sql( "coalesce(feeds.items_last_updated,'1970-01-01') desc" ) )
  end

  ##################################
  # attribute reader aliases
  #
  #  note: CANNOT use alias_method :name, :title
  #         will NOT work for non-existing/on-demand-generated methods in activerecord
  #
  #   use rails alias_attribute :new, :old  (incl. reader/predicate/writer)
  #   or use alias_attr, alias_attr_reader, alias_attr_writer from activerecord/utils

  alias_attr_reader :name,         :title     # alias    for title
  alias_attr_reader :description,  :summary   # alias    for summary
  alias_attr_reader :desc,         :summary   # alias(2) for summary
  alias_attr_reader :subtitle,     :summary   # alias(3) for summary
  alias_attr_reader :link,         :url       # alias    for url
  alias_attr_reader :html_url,     :url       # alias(2) for url
  alias_attr_reader :feed,         :feed_url  # alias    for feed_url

  alias_attr_reader :author_name,  :author    # alias    for author
  alias_attr_reader :owner_name,   :author    # alias(2) for author
  alias_attr_reader :owner,        :author    # alias(3) for author
  alias_attr_reader :author_email, :email     # alias    for email
  alias_attr_reader :author_email, :email     # alias(2) for email


  #################
  ## attributes with fallbacks or (auto-)backups  - use feed.data.<attribute> for "raw" / "original" access
  def url()        read_attribute_w_fallbacks( :url,      :auto_url );      end
  def title()      read_attribute_w_fallbacks( :title,    :auto_title );    end
  def feed_url()   read_attribute_w_fallbacks( :feed_url, :auto_feed_url ); end

  def url?()       url.present?;       end
  def title?()     title.present?;     end
  def feed_url?()  feed_url.present?;  end

  ## note:
  ##   only use fallback for updated, that is, updated (or published)
  ##    ~~do NOT use fallback for published / created    -- why? why not?~~
  ##    add items_last_updated  to updated as last fall back - why? why not?
  def updated()    read_attribute_w_fallbacks( :updated,   :published );  end
  def published()  read_attribute_w_fallbacks( :published, :updated, );   end

  def updated?()   updated.present?;  end
  def published?() published.present?;  end

  #############
  #  add convenience date attribute helpers / readers
  #  - what to return if date is nil? - return nil or empty string or 'n/a' or '?' - why? why not?
  #
  # date
  # date_iso   |  date_iso8601
  # date_822   |  date_rfc2822 | date_rfc822

  def date()        updated; end

  def date_iso()    date ? date.iso8601 : ''; end
  alias_method :date_iso8601, :date_iso

  def date_822()    date ? date.rfc822 : ''; end
  alias_method :date_rfc2822, :date_822
  alias_method :date_rfc822,  :date_822


  ## "raw"  access via data "proxy" helper
  ## e.g. use  feed.data.updated
  ##           feed.data.updated? etc.
  class Data
    def initialize( feed ) @feed = feed; end

    def url()         @feed.read_attribute( :url );      end      # "regular" url incl. auto_url fallback / (auto-)backup
    def title()       @feed.read_attribute( :title );    end
    def feed_url()    @feed.read_attribute( :feed_url );  end
    def url?()        url.present?;       end
    def title?()      title.present?;     end
    def feed_url?()   feed_url.present?;  end

    def updated()     @feed.read_attribute(:updated); end           # "regular" updated incl. published fallback
    def published()   @feed.read_attribute(:published); end         # "regular" published incl. updated fallback
    def updated?()    updated.present?;    end
    def published?()  published.present?;  end
  end # class Data
  ## use a different name for data - why? why not?
  ##    e.g. inner, internal, readonly or r, raw, table, direct, or ???
  def data()   @data ||= Data.new( self ); end


  def deep_update_from_struct!( data )

    logger = LogUtils::Logger.root

    ## note: handle case with empty feed, that is, feed with NO items / entries
    ##                                                    (e.g. data.items.size == 0).
    if data.items.size > 0

      #####
      ## apply some fix-up for "broken" feed data
      fix_dates( data )


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
          logger.info "** SKIPPING | #{item.title}"
          logger.info "  no include terms match: #{includes}"
          next   ## skip to next item
        end

        item_rec = Item.find_by_guid( item.guid )
        if item_rec.nil?
          item_rec  = Item.new
          logger.info "** NEW | #{item.title}"
        else
          ## todo: check if any attribs changed
          logger.info "UPDATE | #{item.title}"
        end

        item_rec.feed_id = id        # feed_rec.id - add feed_id fk_ref
        item_rec.fetched = fetched   # feed_rec.fetched

        item_rec.update_from_struct!( item )
      end  # each item


      ###
      #  delete (old) feed items if no longer in feed AND
      #   date range is in (lastest/current) feed list
      #
      #  thanks to Harry Wood
      #   see https://github.com/feedreader/pluto/pull/16
      #    for more comments

      #  todo/fix: use a delete feature/command line flag to make it optional - why? why not?

      guids_in_feed = data.items.map {|item| item.guid }
      earliest_still_in_feed = data.items.min_by {|item| item.published }.published

      items_no_longer_present =
        Item
          .where(feed_id: id)
          .where.not(published: nil)
          .where("published > ?", earliest_still_in_feed)
          .where.not(guid: guids_in_feed)

      unless items_no_longer_present.empty?
        logger.info "#{items_no_longer_present.size} items no longer present in the feed (presumed removed at source). Deleting from planet db"
        items_no_longer_present.each do |item|
          logger.info "** DELETE | #{item.title}"
          item.destroy
        end
      end


      #  update  cached value last published for item
      ##  todo/check: force reload of items - why? why not??
      last_item_rec = items.latest.limit(1).first  # note limit(1) will return relation/arrar - use first to get first element or nil from ary
      if last_item_rec
        if last_item_rec.updated?   ## note: checks for updated & published with attr_reader_w_fallback
          self.items_last_updated = last_item_rec.updated
          ## save!  ## note: will get save w/ update_from_struct!  - why? why not??
        else
          ## skip - no updated / published present
        end
      end
    end  # check for if data.items.size > 0  (that is, feed has feed items/entries)

    update_from_struct!( data )
  end # method deep_update_from_struct!


  # try to get date from slug in url
  #  e.g. /news/2019-10-17-growing-ruby-together
  FIX_DATE_SLUG_RE = %r{\b
                          (?<year>[0-9]{4})
                             -
                          (?<month>[0-9]{2})
                             -
                          (?<day>[0-9]{2})
                        \b}x

  ###################################################
  #   helpers to fix-up some "broken" feed data
  def fix_dates( data )

    ## check for missing / no dates
    ##   examples
    ##    - rubytogether feed @ https://rubytogether.org/news.xml
    data.items.each do |item|
      if item.updated.nil?  &&
         item.published.nil?
          ## try to get date from slug in url
          ##  e.g. /news/2019-10-17-growing-ruby-together
          if (m=FIX_DATE_SLUG_RE.match( item.url ))
            ## todo/fix: make sure DateTime gets utc (no timezone/offset +000)
            published = DateTime.new( m[:year].to_i(10),
                                      m[:month].to_i(10),
                                      m[:day].to_i(10) )
            item.published_local  = published
            item.published        = published
          end
      end
    end


    ## check if all updated dates are the same (uniq count is 1)
    ##   AND if all published dates are present
    ##  than assume "fake" updated dates and nullify updated dates
    ##   example real-world "messed-up" feeds include:
    ##   -  https://bundler.io/blog/feed.xml
    ##   -  https://dry-rb.org/feed.xml
    ##
    ##  todo/check - limit to atom feed format only - why? why not?

    count           = data.items.size
    count_published = data.items.reduce( 0 ) {|sum,item| sum += 1  if item.published; sum }

    if count == count_published
      uniq_count_updated  = 0
      last_updated        = nil

      data.items.each do |item|
        uniq_count_updated += 1   if item.updated != last_updated
        last_updated = item.updated
      end

      if uniq_count_updated == 1
        puts "bingo!! nullify all updated dates"
        ## todo/fix: log report updated date fix!!!!
        data.items.each do |item|
          item.updated       = nil
          item.updated_local = nil
        end
      end
    end
  end


  def update_from_struct!( data )
    logger = LogUtils::Logger.root

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
        format:         data.format,
        updated:        data.updated,
        published:      data.published,
        summary:        data.summary,
        generator:      data.generator.to_s,    ## note: use single-line/string generator stringified -- might return null (if no data)

        ## note: always auto-update auto_* fields for now
        auto_title:     data.title,
        auto_url:       data.url,
        auto_feed_url:  data.feed_url,
      }

    if debug?
        ## puts "*** dump feed_attribs:"
        ## pp feed_attribs
        logger.debug "*** dump feed_attribs w/ class types:"
        feed_attribs.each do |key,value|
          logger.debug "  #{key}: >#{value}< : #{value.class.name}"
        end
    end

    update!( feed_attribs )
  end

end  # class Feed


  end # module Model
end # module Pluto
