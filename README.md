lets you modify a Cgi Script before it gets executed.

It's like a proxy, kinda.

The neat thing is it works cross-platform over http and is relatively lightweight.
It is also an HTTP protocol so is cachable.
Langauages have mostly done the same.

# CgiProxy
 
  Sends CGI environment to a server, then updates
  those variables with the response.
 
   Example CGI PARAMS:
   http://ken.coar.org/cgi/draft-coar-cgi-v11-03.txt
 
     AUTH_TYPE CONTENT_LENGTH CONTENT_TYPE GATEWAY_INTERFACE
     PATH_INFO PATH_TRANSLATED QUERY_STRING REMOTE_ADDR REMOTE_HOST
     AUTH_TYPE CONTENT_LENGTH CONTENT_TYPE GATEWAY_INTERFACE
     PATH_INFO PATH_TRANSLATED QUERY_STRING REMOTE_ADDR REMOTE_HOST
     REMOTE_IDENT REMOTE_USER REQUEST_METHOD SCRIPT_NAME SERVER_NAME
     SERVER_PORT SERVER_PROTOCOL SERVER_SOFTWARE
 
   And anything that is of the format:
 
     HTTP_* 
     where * corresponse to an http header name
 
   For example,
     Content-Length becomes HTTP_CONTENT_LENGTH
 
   this is the format followed by:
   - python's wsgi http://ken.coar.org/cgi/draft-coar-cgi-v11-03.txt
 
   - ruby's rack http://rack.rubyforge.org/doc/files/SPEC.html
 
   - php's `$_SERVER` http://php.net/manual/en/reserved.variables.server.php
 
   - and the spec: http://ken.coar.org/cgi/draft-coar-cgi-v11-03.txt

# Usage

    require 'rack/cgi-proxy'

    # Cloud CGI Proxy as a Service (CPaaS)
    ENV['CLOUD_PROXY_URL'] ||= 'http://localhost:4567/user1'
    use Rack::CgiProxy, ENV['CLOUD_PROXY_URL']

    Your Cloud Proxy modifies the Request at the "CGI" level.
    I'm not totally sure if this is a good idea, but you can 
    definitely have fun / do some damage with it...

# Testing

  totally went poor man's testing on this

  fire up your RequestInspector with rack via:

    $ bundle exec rackup
    start rack on port 9292

  fire up your Cloud CGI Proxy

    $ bundle exec ruby proxy.rb
    start sinatra on port 4567

  test it out

    $ ./test.sh
    ...
    GET /?*post=query* => POST request, query string as post body
    GET http://localhost:9292?post=query&foo=bar&jay=zee
    Hello, POST: {"post"=>"query", "foo"=>"bar", "jay"=>"zee", "splat"=>["/"], "captures"=>["/"]} 
    ....
