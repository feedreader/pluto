require 'hoe'
require './lib/pluto/version.rb'

Hoe.spec 'pluto' do

  self.version = Pluto::VERSION

  self.summary = 'pluto - Another Planet Generator'
  self.description = 'pluto - Another Planet Generator (Lets You Build Web Pages from Published Web Feeds)'

  self.urls    = ['https://github.com/feedreader/pluto']

  self.author  = 'Gerald Bauer'
  self.email   = 'feedreader@googlegroups.com'

  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.md'
  self.history_file = 'History.md'

  self.extra_deps = [
    ['pakman',    '>= 0.5'], 
    ['fetcher',   '>= 0.4.1'],    # use min. 0.4.1 - added cache/conditional GET support
    ['logutils',  '>= 0.6'],
    ['feedutils', '>= 0.3.2'],    #  use min. 0.3.2 - added fix for rss.item.guid missing; no more auto-summary in atom
    ['props',     '>= 1.0.2'],    #  use min. 1.0.2 - added ini support
    ['textutils', '>= 0.6.8'],    # future: add some filters (for include/exclude)
    ['gli',       '>= 2.5.6']
    ## ['activerecord', '~> 3.2'],  #  NB:  soft dependency, will include activesupport,etc.
  ]


  self.licenses = ['Public Domain']

  self.spec_extras = {
   :required_ruby_version => '>= 1.9.2'
  }

end
