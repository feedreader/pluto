require 'hoe'
require './lib/pluto/version.rb'

Hoe.spec 'pluto-models' do

  self.version = Pluto::VERSION

  self.summary = 'pluto-models - planet models and generator machinery for easy (re)use'
  self.description = summary

  self.urls    = ['https://github.com/feedreader/pluto-models']

  self.author  = 'Gerald Bauer'
  self.email   = 'feedreader@googlegroups.com'

  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.md'
  self.history_file = 'HISTORY.md'

  self.extra_deps = [
    ['pakman',        '>= 0.5.0'], 
    ['fetcher',       '>= 0.4.4'],
    ['logutils',      '>= 0.6.1'],
    ['feedutils',     '>= 0.4.0'],
    ['props',         '>= 1.1.2'],
    ['textutils',     '>= 0.10.0'],
    ['gli',           '>= 2.12.2'],
    ['activerecord'],
    ['logutils-activerecord', '>= 0.2.0'],
    ['props-activerecord', '0.1.0'],
    ['activityutils', '>= 0.1.0' ],
  ]


  self.licenses = ['Public Domain']

  self.spec_extras = {
    required_ruby_version: '>= 1.9.2'
  }

end
