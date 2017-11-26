# encoding: utf-8

module Pluto
  module Model

class Item < ActiveRecord::Base
  self.table_name = 'items'

  belongs_to :feed

  ## todo/fix:
  ##  use a module ref or something; do NOT include all methods - why? why not?
  include TextUtils::HypertextHelper   ## e.g. lets us use strip_tags( ht )
  include FeedFilter::AdsFilter        ## e.g. lets us use strip_ads( ht )

  include LogUtils::Logging

  ##################################
  # attribute reader aliases
  def name()        title;    end  # alias for title
  def description() summary;  end  # alias     for summary  -- also add descr shortcut??
  def desc()        summary;  end  # alias (2) for summary  -- also add descr shortcut??
  def link()        url;      end  # alias for url


  def self.latest
    # note: order by first non-null datetime field
    #   coalesce - supported by sqlite (yes), postgres (yes)

    # note: if not updated,published use hardcoded 1971-01-01 for now
    order( "coalesce(items.updated,items.published,'1971-01-01') desc" )
  end

  def updated?()    read_attribute(:updated).present?;  end
  def published?()  read_attribute(:published).present?;  end   # note: published is basically an alias for created

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


  def update_from_struct!( data )
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

    logger.debug "*** dump item_attribs w/ class types:"
    item_attribs.each do |key,value|
      next if [:summary,:content].include?( key )   # skip summary n content
      logger.debug "  #{key}: >#{value}< : #{value.class.name}"
    end

    update_attributes!( item_attribs )
  end

end  # class Item


  end # module Model
end # module Pluto
