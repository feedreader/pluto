require 'hoe'
require './lib/pluto/version.rb'

Hoe.spec 'pluto-models' do

  self.version = Pluto::VERSION

  self.summary = "pluto-models - planet schema 'n' models for easy (re)use"
  self.description = summary

  self.urls    = ['https://github.com/feedreader/pluto.models']

  self.author  = 'Gerald Bauer'
  self.email   = 'feedreader@googlegroups.com'

  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.md'
  self.history_file = 'HISTORY.md'

  self.extra_deps = [
    ['props',         '>= 1.1.2'],
    ['logutils',      '>= 0.6.1'],
    ['feedparser',    '>= 1.0.0'],
    ['textutils',     '>= 1.0.1'],
    ['activerecord'],
    ['logutils-activerecord', '>= 0.2.0'],
    ['props-activerecord',    '>= 0.1.0'],
    ['activityutils',         '>= 0.1.0'],
    ['activerecord-utils',    '>= 0.2.0'],
  ]


  self.licenses = ['Public Domain']

  self.spec_extras = {
    required_ruby_version: '>= 1.9.2'
  }

end
