# pluto-models gem - planet schema 'n' models for easy (re)use

* home  :: [github.com/feedreader/pluto](https://github.com/feedreader/pluto)
* bugs  :: [github.com/feedreader/pluto/issues](https://github.com/feedreader/pluto/issues)
* gem   :: [rubygems.org/gems/pluto-models](https://rubygems.org/gems/pluto-models)
* rdoc  :: [rubydoc.info/gems/pluto-models](http://rubydoc.info/gems/pluto-models)
* forum :: [groups.google.com/group/wwwmake](http://groups.google.com/group/wwwmake)



## Usage

### Models

Site • Feed • Item • Subscription

![](pluto-models.png)


#### Site

```
class Site
  has_many :subscriptions
  has_many :feeds, :through => :subscriptions
  has_many :items, :through => :feeds
  ...
end
```

#### Feed

```
class Feed
  has_many :items
  has_many :subscriptions
  has_many :sites, :through => :subscriptions
  ...
end
```

#### Item

```
class Item
  belongs_to :feed
  ...
end
```

#### Subscription

```
class Subscription
  belongs_to :site
  belongs_to :feed
  ...
end
```



### Examples

```
DB_CONFIG = {
  adapter: 'sqlite3',
  database: './planet.db'
}

Pluto.connect( DB_CONFIG )

Pluto::Model::Item.latest.limit(10).each_with_index do |item,i|
  puts "[#{i+1}] #{item.title}"

  if item.content
    puts item.content
  elsif item.summary
    puts item.summary
  else
    ## warn: no content found
  end
end
```



## Real World Usage

- [`pluto`](https://github.com/feedreader/pluto) - planet generator command line tool using the pluto-models gem
- [`pluto.live.starter`](https://github.com/plutolive/pluto.live.starter) - sample planet site; sinatra web app starter template in ruby using the pluto-models gem
- [`pluto.live`](https://github.com/plutolive/pluto.live) - sample planet site; rails web app in ruby using the pluto-models gem



## License

![](https://publicdomainworks.github.io/buttons/zero88x31.png)

The `pluto-models` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.

## Questions? Comments?

Send them along to the [wwwmake Forum/Mailing List](http://groups.google.com/group/wwwmake).
Thanks!
