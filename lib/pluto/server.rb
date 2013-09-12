######
# NB: use rackup to startup Sinatra service (see config.ru)
#
#  e.g. config.ru:
#   require './boot'
#   run Pluto::Server


# 3rd party libs/gems

require 'sinatra/base'


module Pluto

class Server < Sinatra::Base

  def self.banner
    "pluto-service #{Pluto::VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}] on Sinatra/#{Sinatra::VERSION} (#{ENV['RACK_ENV']})"
  end

  PUBLIC_FOLDER = "#{Pluto.root}/lib/pluto/server/public"
  VIEWS_FOLDER  = "#{Pluto.root}/lib/pluto/server/views"

  puts "[boot] pluto-service - setting public folder to: #{PUBLIC_FOLDER}"
  puts "[boot] pluto-service - setting views folder to: #{VIEWS_FOLDER}"

  set :public_folder, PUBLIC_FOLDER   # set up the static dir (with images/js/css inside)   
  set :views,         VIEWS_FOLDER    # set up the views dir

  set :static, true   # set up static file routing


  #######################
  # Models
  
  include Models   # e.g. Feed, Item, Site, etc.

  #################
  # Helpers

  def path_prefix
    request.env['SCRIPT_NAME']
  end

  def sites_path
    "#{path_prefix}/sites"
  end

  def feeds_path
    "#{path_prefix}/feeds"
  end

  def items_path
    "#{path_prefix}/items"
  end
  
  def root_path
    "#{path_prefix}/"
  end

  def root_url
    url( '/' )
  end


  def link_to( text, url, opts={} )
    attributes = ""
    opts.each do |key,value|
      attributes << "#{key}='#{value}' "
    end
    "<a href='#{url}' #{attributes}>#{text}</a>"
  end


  ##############################################
  # Controllers / Routing / Request Handlers

  get '/' do
    redirect( sites_path )
  end

  get '/sites' do
    erb :sites   # needed or default fallthrough possible ???
  end

  get '/feeds' do
    erb :feeds   # needed or default fallthrough possible ???
  end

  get '/items' do
    erb :items   # needed or default fallthrough possible ???
  end

  # todo/fix: make a generic route for erb w /regex
  #  to auto-allow all routes not just / w/ site data

  get '/d*' do
    erb :debug
  end


end # class Server
end #  module Pluto


# say hello
puts Pluto::Server.banner
