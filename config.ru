require 'bundler'
Bundler.require
require 'sinatra/base'

# Cloud CGI Proxy as a Service (CPaaS)
ENV['CLOUD_PROXY_URL'] ||= 'http://localhost:4567/user1'
use Rack::CgiProxy, ENV['CLOUD_PROXY_URL']

class RequestIntrospector < Sinatra::Base
  # show ALL the methods!
  %w{get post put delete head}.each do |http_method|
    eval <<-RUBY
      #{http_method} '*' do
        "Hello, #{http_method.upcase}: "  + params.inspect + "\n"
      end
    RUBY
  end
end

# drop it like its hot
run RequestIntrospector
