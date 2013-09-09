require 'hoe'
require './lib/pluto/version.rb'

Hoe.spec 'pluto' do

  self.version = Pluto::VERSION

  self.summary = 'pluto - Another Planet Generator'
  self.description = 'pluto - Another Planet Generator (Lets You Build Web Pages from Published Web Feeds)'

  self.urls    = ['https://github.com/geraldb/pluto']

  self.author  = 'Gerald Bauer'
  self.email   = 'webslideshow@googlegroups.com'

  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.markdown'
  self.history_file = 'History.markdown'

  self.extra_deps = [
    ['pakman', '>= 0.5'], 
    ['fetcher', '>= 0.3'],
    ['logutils', '>= 0.6']
    ## ['activerecord', '~> 3.2'],  #  NB:  soft dependency, will include activesupport,etc.
  ]

  self.licenses = ['Public Domain']

  self.spec_extras = {
   :required_ruby_version => '>= 1.9.2'
  }

end
