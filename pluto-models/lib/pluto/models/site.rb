# encoding: utf-8

module Pluto
  module Model

class Site < ActiveRecord::Base



  self.table_name = 'sites'

  has_many :subscriptions
  has_many :feeds, :through => :subscriptions
  has_many :items, :through => :feeds


  ##################################
  # attribute reader aliases
  alias_attr_reader  :name, :title          # alias for title

  alias_attr_reader  :owner_name,   :author   # alias    for author
  alias_attr_reader  :owner,        :author   # alias(2) for author
  alias_attr_reader  :author_name,  :author   # alias(3) for author

  alias_attr_reader  :owner_email,  :email    # alias    for email
  alias_attr_reader  :author_email, :email    # alias(2) for email



  def self.deep_create_or_update_from_hash!( name, config, opts={} )

    ## note: allow (optional) config of site key too
    site_key = config['key'] || config['slug']
    if site_key.nil?
      ## if no key configured; use (file)name; remove -_ chars
      ##   e.g. jekyll-meta becomes jekyllmeta etc.
      site_key = name.downcase.gsub( /[\-_]/, '' )
    end

    site_rec = Site.find_by_key( site_key )
    if site_rec.nil?
      site_rec        = Site.new
      site_rec.key    = site_key
    end

    site_rec.deep_update_from_hash!( config, opts )
    site_rec
  end


  def deep_update_from_hash!( config, opts={} )

    logger = LogUtils::Logger.root

    site_attribs = {
      title:   config['title']  || config['name'],   # support either title or name
      url:     config['source'] || config['url'],    # support source or url   for source url for auto-update (optional)
      author:  config['author'] || config['owner'],
      email:   config['email'],
      updated: Time.now,   ## track last_update via pluto (w/ update_subscription_for fn)
    }

    ## note: allow (optional) config of site key too
    site_key = config['key'] || config['slug']
    site_attribs[:key] = site_key   if site_key


    logger.debug "site_attribs: #{site_attribs.inspect}"

    if new_record?
      ## use object_id: site.id and object_type: Site
      ## change - model/table/schema!!!
      Activity.create!( text: "new site >#{key}< - #{title}" )
    end

    update!( site_attribs )


    # -- log update activity
    ##  Activity.create!( text: "update subscriptions for site >#{key}<" )

    #### todo/fix:
    ##  double check - how to handle delete
    ##    feeds might get referenced by other sites
    ##   cannot just delete feeds; only save to delete join table (subscriptions)
    ##   check if feed "lingers" on with no reference (to site)???

    # clean out subscriptions and add again
    logger.debug "before site.subscriptions.delete_all - count: #{subscriptions.count}"
    # note: use destroy_all NOT delete_all (delete_all tries by default only nullify)
    subscriptions.destroy_all
    logger.debug "after site.subscriptions.delete_all - count: #{subscriptions.count}"


    config.each do |k, v|

      ## todo: downcase key - why ??? why not???

      # skip "top-level" feed keys e.g. title, etc. or planet planet sections (e.g. planet,defaults)
      next if ['key','slug',
               'title','name','name2','title2','subtitle',
               'source', 'url',
               'include','includes','exclude','excludes',
               'feeds',
               'author', 'owner', 'email',
               'planet','defaults'].include?( k )

      ### todo/check:
      ##   check value - must be hash
      #     check if url or feed_url present
      #      that is, check for required props/key-value pairs

      feed_key   = k.to_s.dup
      feed_hash  = v

      # todo/fix: use title from feed?
      #  e.g. fill up auto_title, auto_url, etc.

      feed_attribs = {
        feed_url: feed_hash[ 'feed' ]  || feed_hash[ 'feed_url' ] || feed_hash[ 'xml_url' ],
        url:      feed_hash[ 'link' ]  || feed_hash[ 'url' ] || feed_hash[ 'html_url' ],
        title:    feed_hash[ 'title' ] || feed_hash[ 'name' ],
## note: title2 no longer supported; use summary or subtitle?
###     title2:   feed_hash[ 'title2' ] || feed_hash[ 'name2' ] || feed_hash[ 'subtitle'],
        includes: feed_hash[ 'includes' ] || feed_hash[ 'include' ],
        excludes: feed_hash[ 'excludes' ] || feed_hash[ 'exclude' ],
        author:   feed_hash[ 'author' ] || feed_hash[ 'owner' ],
        email:    feed_hash[ 'email' ],
        avatar:   feed_hash[ 'avatar'   ] || feed_hash[ 'face'],
        location: feed_hash[ 'location' ],
        github:   feed_hash[ 'github'  ],
        twitter:  feed_hash[ 'twitter' ],
        rubygems: feed_hash[ 'rubygems' ],
        meetup:   feed_hash[ 'meetup' ],   ### -- remove from schema - virtual attrib ?? - why? why not??
      }

      feed_attribs[:encoding] = feed_hash['encoding']||feed_hash['charset']    if feed_hash['encoding']||feed_hash['charset']

#####
##
# auto-fill; convenience helpers

      if feed_hash['meetup']
##  link/url      = http://www.meetup.com/vienna-rb
##  feed/feed_url = http://www.meetup.com/vienna-rb/events/rss/vienna.rb/

        feed_attribs[:url]      = "http://www.meetup.com/#{feed_hash['meetup']}"    if feed_attribs[:url].nil?
        feed_attribs[:feed_url] = "http://www.meetup.com/#{feed_hash['meetup']}/events/rss/#{feed_hash['meetup']}/"    if feed_attribs[:feed_url].nil?
      end

      if feed_hash['googlegroups']
##  link/url      = https://groups.google.com/group/beerdb or
##                  https://groups.google.com/forum/#!forum/beerdb
##  feed/feed_url = https://groups.google.com/forum/feed/beerdb/topics/atom.xml?num=15

        feed_attribs[:url]      = "https://groups.google.com/group/#{feed_hash['googlegroups']}"    if feed_attribs[:url].nil?
        feed_attribs[:feed_url] = "https://groups.google.com/forum/feed//#{feed_hash['googlegroups']}/topics/atom.xml?num=15"    if feed_attribs[:feed_url].nil?
      end

      if feed_hash['github'] && feed_hash['github'].index('/')  ## e.g. jekyll/jekyll
## link/url      = https://github.com/jekyll/jekyll
## feed/feed_url = https://github.com/jekyll/jekyll/commits/master.atom

        feed_attribs[:url]      = "https://github.com/#{feed_hash['github']}"    if feed_attribs[:url].nil?
        feed_attribs[:feed_url] = "https://github.com/#{feed_hash['github']}/commits/master.atom"    if feed_attribs[:feed_url].nil?
      end

      if feed_hash['rubygems'] && feed_attribs[:url].nil? && feed_attribs[:feed_url].nil?
## link/url      = http://rubygems.org/gems/jekyll
## feed/feed_url = http://rubygems.org/gems/jekyll/versions.atom

        feed_attribs[:url]      = "http://rubygems.org/gems/#{feed_hash['rubygems']}"    if feed_attribs[:url].nil?
        feed_attribs[:feed_url] = "http://rubygems.org/gems/#{feed_hash['rubygems']}/versions.atom"    if feed_attribs[:feed_url].nil?
      end


      logger.info "Updating feed subscription >#{feed_key}< - >#{feed_attribs[:feed_url]}<..."

      feed_rec = Feed.find_by_key( feed_key )
      if feed_rec.nil?
        feed_rec           = Feed.new
        feed_attribs[:key] = feed_key

        ## use object_id: feed.id and object_type: Feed
        ## change - model/table/schema!!!
        ## todo: add parent_action_id - why? why not?
        Activity.create!( text: "new feed >#{feed_key}< - #{feed_attribs[:title]}" )
      end

      feed_rec.update!( feed_attribs )

      #  add subscription record
      #   note: subscriptions get cleaned out on update first (see above)
      subscriptions.create!( feed_id: feed_rec.id )
    end

  end # method deep_update_from_hash!

end # class Site


  end # module Model
end # module Pluto
