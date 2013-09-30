
module Pluto

class CreateDb < ActiveRecord::Migration
    
  def up
    create_table :sites do |t|
      t.string   :title,     :null => false    # e.g Planet Ruby, Planet JavaScript, etc.
      t.string   :key,       :null => false    # e.g. ruby, js, etc.
      t.datetime :fetched_at   #  last fetched/checked date -- make not null ??

      t.timestamps  # created_at, updated_at
    end

    create_table :subscriptions do |t|   # has_many join table (sites/feeds)
      t.references :site, :null => false
      t.references :feed, :null => false
      t.timestamps
    end

    create_table :feeds do |t|
      t.string  :title        # user supplied titled
      t.string  :auto_title   # "fallback" - auto(fill) title from feed

      t.string  :url          # user supplied site url
      t.string  :auto_url     # "fallback" - auto(fill) url from feed

      t.string  :feed_url       # user supplied feed url
      t.string  :auto_feed_url  # "fallback" - auto discovery feed url from (site) url

      t.string  :title2     # e.g. subtitle (atom)
      t.text    :summary    # e.g. description (rss)

      t.string  :generator   # feed generator (e.g. wordpress, etc.)  from feed
      
      t.datetime :published_at  # from feed published(atom)+ pubDate(rss)
      t.datetime :built_at      # from feed lastBuiltDate(rss)
      t.datetime :touched_at    # from feed updated(atom)

      # -- our own (meta) fields
      t.datetime :latest_published_at # cache latest item published_at

      t.string  :key,      :null => false
      t.string  :format      # e.g. atom (1.0), rss 2.0, rss 0.7 etc.
      t.string  :etag      # last etag
      t.datetime :fetched_at    # last fetched/checked date
      t.timestamps   # created_at, updated_at
    end

    create_table :items do |t|
      t.string   :title   # todo: add some :null => false ??
      t.string   :guid
      t.string   :url
      t.text     :summary  # e.g. description (rss), summary (atom)
      t.text     :content
      
      t.datetime :published_at   # from feed (published)  + pubDate(rss)
      t.datetime :touched_at     # from feed updated (atom)

      ## todo: add :last_updated_at ??  (NOTE: updated_at already take by auto-timestamps)
      t.references :feed, :null => false

      t.datetime :fetched_at   # last fetched/check date
      t.timestamps   # created_at, updated_at
      
      ## t.string   :author
      ## todo: add author/authors, category/categories
    end

    create_table :actions do |t|
      t.string   :title                # e.g. new site, new subscription, update feeds, etc.
      t.string   :object            # todo: find better names for action attribs ??
      t.string   :object_type
      t.timestamps
    end
    
  end
    
  def down
    raise ActiveRecord::IrreversibleMigration
  end
    
end  # class CreateDb
   
end  # module Pluto
