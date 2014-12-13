# encoding: utf-8

module Pluto

class CreateDb < ActiveRecord::Migration

  def up
    create_table :sites do |t|
      t.string   :title,     :null => false    # e.g Planet Ruby, Planet JavaScript, etc.
      t.string   :key,       :null => false    # e.g. ruby, js, etc.

      ############
      # filters (site-wide)
      t.string   :includes  # regex
      t.string   :excludes  # regex

      ######################
      # for auto-update of feed list/site config

      t.string   :url    # source url for auto-update (optional)

      ## note: make sure to use same fields for update check as feed 

      t.datetime :fetched   #  last fetched/checked date -- make not null ??
      t.integer  :http_code   # last http status code e.g. 200,404,etc.
      t.string   :http_etag    # last http header etag
      ## note: save last-modified header as text (not datetime) - pass through as is
      t.string   :http_last_modified   # last http header last-modified - note: save header as plain text!!! pass along in next request as-is
      t.string   :http_server    # last http server header if present

      # note: do NOT store body content (that is, text) and md5 digest
      #   use git! and github! commit will be http_etag!!

      t.datetime :fetched    # last fetched/checked date

      #############
      # more fields

      t.timestamps  # created_at, updated_at
    end

    create_table :subscriptions do |t|   # has_many join table (sites/feeds)
      t.references :site, :null => false
      t.references :feed, :null => false
      t.timestamps
    end

    create_table :feeds do |t|
      t.string  :title        # user supplied title
      t.string  :auto_title   # "fallback" - auto(fill) title from feed

      t.string  :title2        # user supplied title2
      t.string  :auto_title2   # "fallback" - auto(fill) title2 from feed e.g. subtitle (atom)

      t.string  :url          # user supplied site url
      t.string  :auto_url     # "fallback" - auto(fill) url from feed

      t.string  :feed_url       # user supplied feed url
      t.string  :auto_feed_url  # "fallback" - auto discovery feed url from (site) url

      t.text    :summary    # e.g. description (rss)

      t.string  :generator   # feed generator (e.g. wordpress, etc.)  from feed
      
      t.datetime :published  # from feed published(atom)+ pubDate(rss)
      t.datetime :built      # from feed lastBuiltDate(rss)
      t.datetime :touched    # from feed updated(atom)

      ### extras (move to array for custom fields or similar??)
      t.string   :github   # github handle  (optional)
      t.string   :twitter  # twitter handle (optional)
      t.string   :avatar   # gravator or hackergotchi handle (optional)

      ### add class/kind field e.g.
      # - personal feed/blog/site, that is, individual author
      # - team blog/site
      # - org (anization) or com(pany blog/site)
      # - newsfeed (composite)
      # - other  (link blog?, podcast?) - why? why not??

      ############
      # filters
      t.string   :includes  # regex
      t.string   :excludes  # regex
      # todo: add generic filter list e.g. t.string :filters  (comma,pipe or space separated method names?)

      # -- our own (meta) fields
      t.datetime :last_published # cache last (latest) published for items

      t.string  :key,      :null => false
      t.string  :format      # e.g. atom (1.0), rss 2.0, rss 0.7 etc.

      t.integer  :http_code   # last http status code e.g. 200,404,etc.
      t.string   :http_etag    # last http header etag
      ## note: save last-modified header as text (not datetime) - pass through as is
      t.string   :http_last_modified   # last http header last-modified - note: save header as plain text!!! pass along in next request as-is
      t.string   :http_server    # last http server header if present

      t.string   :md5       # md5 hash of body
      t.text     :body      # last http response body (complete feed!)

      t.datetime :fetched    # last fetched/checked date

      t.timestamps   # created_at, updated_at
    end


    create_table :items do |t|
      t.string   :guid
      t.string   :url

      ## note: title may contain more than 255 chars!! use text for sure!
      ## e.g. Rails Girls blog has massive titles in feed
      
      t.text     :title   # todo: add some :null => false ??
      t.text     :summary  # e.g. description (rss), summary (atom)
      t.text     :content
      
      t.datetime :published   # from feed (published)  + pubDate(rss)
      t.datetime :touched     # from feed updated (atom)

      ## todo: add :last_updated_at ??  (NOTE: updated_at already take by auto-timestamps)
      t.references :feed, :null => false

      t.datetime :fetched   # last fetched/check date
      t.timestamps   # created_at, updated_at

      ## t.string   :author
      ## todo: add author/authors, category/categories
    end

  end
    
  def down
    raise ActiveRecord::IrreversibleMigration
  end
    
end  # class CreateDb
   
end  # module Pluto
