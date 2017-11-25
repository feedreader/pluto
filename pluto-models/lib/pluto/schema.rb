# encoding: utf-8

module Pluto

class CreateDb

def up

ActiveRecord::Schema.define do
    create_table :sites do |t|
      t.string   :key,       null: false    # e.g. ruby, js, etc.
      t.string   :title,     null: false    # e.g Planet Ruby, Planet JavaScript, etc.

      t.string   :author    # owner_name, author_name
      t.string   :email     # owner_email, author_email
      t.datetime :updated   # date for subscription list last updated via pluto

      ############
      # filters (site-wide)
      t.string   :includes  # regex
      t.string   :excludes  # regex


      ######################
      # for auto-update of feed list/site config

      t.string   :url    # source url for auto-update (optional)

      ## note: make sure to use same fields for update check as feed

      t.datetime :fetched   #  date for last fetched/checked for feeds via pluto -- make not null ??
      t.integer  :http_code   # last http status code e.g. 200,404,etc.
      t.string   :http_etag    # last http header etag
      ## note: save last-modified header as text (not datetime) - pass through as is
      t.string   :http_last_modified   # last http header last-modified - note: save header as plain text!!! pass along in next request as-is
      t.string   :http_server    # last http server header if present

      # note: do NOT store body content (that is, text) and md5 digest
      #   use git! and github! commit will be http_etag!!
      t.string   :md5       # md5 hash of body


      #############
      # more fields

      t.timestamps  # created_at, updated_at
    end


    create_table :subscriptions do |t|   # has_many join table (sites/feeds)
      t.references :site, null: false
      t.references :feed, null: false
      t.timestamps
    end

    create_table :feeds do |t|
      t.string  :key,       null: false
      t.string  :encoding,  null: false, default: 'utf8'  # charset encoding; default to utf8
      t.string  :format      # e.g. atom (1.0), rss 2.0, etc.

      t.string  :title          # user supplied title
      t.string  :url            # user supplied site url
      t.string  :feed_url       # user supplied feed url

      t.string  :auto_title     # "fallback" - auto(fill) title from feed
      t.string  :auto_url       # "fallback" - auto(fill) url from feed
      t.string  :auto_feed_url  # "fallback" - auto discovery feed url from (site) url

      t.text    :summary    # e.g. description (rss), subtitle (atom)
      ## todo: add auto_summary  - why? why not?

      t.string  :generator   # feed generator (e.g. wordpress, etc.)  from feed

      t.datetime :updated    # from feed updated(atom) + lastBuildDate(rss)
      t.datetime :published  # from feed published(atom) + pubDate(rss) - note: published basically an alias for created


      ### extras (move to array for custom fields or similar??)
      t.string   :author    # author_name, owner_name
      t.string   :email     # author_email, owner_email
      t.string   :avatar    # gravator or hackergotchi handle (optional)
      t.string   :location  # e.g. Vienna > Austria,  Bamberg > Germany etc. (optional)

      t.string   :github     # github handle  (optional)
      t.string   :rubygems   # rubygems handle (optional)
      t.string   :twitter    # twitter handle (optional)
      t.string   :meetup     # meetup handle (optional)


      ### add class/kind field e.g.
      # - personal feed/blog/site, that is, individual author
      # - team blog/site
      # - org (anization) or com(pany blog/site)
      # - newsfeed (composite)
      # - other  (link blog?, podcast?) - why? why not??

      ############
      # filters (feed-wide)
      t.string   :includes  # regex
      t.string   :excludes  # regex
      # todo: add generic filter list e.g. t.string :filters  (comma,pipe or space separated method names?)

      # -- our own (meta) fields
      t.datetime :items_last_updated  # cache last (latest) updated for items - e.g. latest date from updated item
      t.datetime :fetched    # last fetched date via pluto

      t.integer  :http_code   # last http status code e.g. 200,404,etc.
      t.string   :http_etag    # last http header etag
      ## note: save last-modified header as text (not datetime) - pass through as is
      t.string   :http_last_modified   # last http header last-modified - note: save header as plain text!!! pass along in next request as-is
      t.string   :http_server    # last http server header if present

      t.string   :md5       # md5 hash of body
      t.text     :body      # last http response body (complete feed!)


      t.timestamps   # created_at, updated_at
    end


    create_table :items do |t|
      t.string   :guid
      t.string   :url

      ## note: title may contain more than 255 chars!!
      ## e.g. Rails Girls blog has massive titles in feed
      ## cut-off/limit to 255 - why?? why not??
      ##  also strip tags in titles - why? why not?? - see feed.title2/auto_title2

      t.text     :title   # todo: add some :null => false ??
      t.text     :summary  # e.g. description (rss), summary (atom)
      t.text     :content

      t.datetime :updated     # from feed updated (atom) + pubDate(rss)
      t.datetime :published   # from feed published (atom) -- note: published is basically an alias for created

      ## todo: add :last_updated_at ??  (NOTE: updated_at already take by auto-timestamps)
      t.references :feed, null: false

      t.datetime :fetched   # last fetched/check date via pluto
      t.timestamps   # created_at, updated_at

      ## t.string   :author
      ## todo: add author/authors, category/categories
    end

end # block Schema.define

end # method up

end # class CreateDb

end  # module Pluto
