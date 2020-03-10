# encoding: utf-8

module Pluto
  module Model

class Item < ActiveRecord::Base

## logging w/ ActiveRecord
##   todo/check: check if logger instance method is present by default?
##     only class method present?
##   what's the best way to add logging to activerecord (use "builtin" machinery??)


  def debug?()  Pluto.config.debug?;  end


  self.table_name = 'items'

  belongs_to :feed

  ## todo/fix:
  ##  use a module ref or something; do NOT include all methods - why? why not?
  include TextUtils::HypertextHelper   ## e.g. lets us use strip_tags( ht )
  include FeedFilter::AdsFilter        ## e.g. lets us use strip_ads( ht )


  ##################################
  # attribute reader aliases
  alias_attr_reader :name,        :title      # alias for title
  alias_attr_reader :description, :summary    # alias     for summary  -- also add descr shortcut??
  alias_attr_reader :desc,        :summary    # alias (2) for summary  -- also add descr shortcut??
  alias_attr_reader :link,        :url        # alias for url


  def self.latest
    # note: order by first non-null datetime field
    #   coalesce - supported by sqlite (yes), postgres (yes)

    # note: if not updated,published use hardcoded 1970-01-01 for now
    order( Arel.sql( "coalesce(items.updated,items.published,'1970-01-01') desc" ) )
  end

  ## note:
  ##   only use fallback for updated, that is, updated (or published)
  ##    ~~do NOT use fallback for published / created    -- why? why not?~~
  def updated()    read_attribute_w_fallbacks( :updated, :published ); end
  def published()  read_attribute_w_fallbacks( :published, :updated ); end

  def updated?()   updated.present?;   end
  def published?() published.present?; end

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
  ## e.g. use  item.data.updated
  ##           item.data.updated? etc.
  class Data
    def initialize( item ) @item = item; end

    def updated()     @item.read_attribute(:updated); end           # "regular" updated incl. published fallback
    def published()   @item.read_attribute(:published); end

    def updated?()    updated.present?;    end
    def published?()  published.present?;  end
  end # class Data
  ## use a different name for data - why? why not?
  ##    e.g. inner, internal, readonly or r, raw, table, direct, or ???
  def data()   @data ||= Data.new( self ); end


  def update_from_struct!( data )

    logger = LogUtils::Logger.root

    ## check: new item/record?  not saved?  add guid
    #   otherwise do not add guid  - why? why not?

    ## note: for now also strip ads in summary
    ##  fix/todo: summary (in the future) is supposed to be only plain vanilla text

    item_attribs = {
      guid:         data.guid,   # todo: only add for new records???
      title:        data.title ? strip_tags(data.title)[0...255] : data.title,   ## limit to 255 chars; strip tags
      url:          data.url,
      summary:      data.summary.blank? ? data.summary : strip_ads( data.summary ).strip,
      content:      data.content.blank? ? data.content : strip_ads( data.content ).strip,
      updated:      data.updated,
      published:    data.published,
    }

    if debug?
      logger.debug "*** dump item_attribs w/ class types:"
      item_attribs.each do |key,value|
        next if [:summary,:content].include?( key )   # skip summary n content
        logger.debug "  #{key}: >#{value}< : #{value.class.name}"
      end
    end

    update!( item_attribs )
  end

end  # class Item


  end # module Model
end # module Pluto
