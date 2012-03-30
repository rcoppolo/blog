require 'rubygems'
require 'bundler'
Bundler.require(:default)

require './blog'

DOMAIN = 'www.coppolo.com'

# Redirect to the www version of the domain in production
use Rack::Rewrite do
  r301 %r{.*}, "http://#{DOMAIN}$&", :if => Proc.new {|rack_env|
    rack_env['SERVER_NAME'] != DOMAIN && ENV['RACK_ENV'] == "production"
  }
end

sprockets = Sprockets::Environment.new do |env|
	env.logger = Logger.new(STDOUT)
end

sprockets.append_path 'assets/javascripts'
sprockets.append_path 'assets/stylesheets'

map '/assets' do
	run sprockets
end

run Blog
