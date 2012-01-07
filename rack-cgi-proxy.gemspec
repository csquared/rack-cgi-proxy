# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rack-cgi-proxy/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Chris Continanza"]
  gem.email         = ["christopher.continanza@gmail.com"]
  gem.description   = %q{Modify your CGI environment with a service or two...}
  gem.summary       = %q{Rack middleware for "proxying" request environment to another server via HTTP.}

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "rack-cgi-proxy"
  gem.require_paths = ["lib"]
  gem.version       = Rack::Cgi::Proxy::VERSION

  gem.add_dependency 'rack'
  gem.add_dependency 'rest-client'
  gem.add_dependency 'json'
end
