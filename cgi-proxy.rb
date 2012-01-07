#
# CgiProxy
#
# Sends CGI environment to a server, then updates
# those variables with the response.
#
#  Example CGI PARAMS:
#  http://ken.coar.org/cgi/draft-coar-cgi-v11-03.txt
#
#  AUTH_TYPE CONTENT_LENGTH CONTENT_TYPE GATEWAY_INTERFACE
#  PATH_INFO PATH_TRANSLATED QUERY_STRING REMOTE_ADDR REMOTE_HOST
#  AUTH_TYPE CONTENT_LENGTH CONTENT_TYPE GATEWAY_INTERFACE
#  PATH_INFO PATH_TRANSLATED QUERY_STRING REMOTE_ADDR REMOTE_HOST
#  REMOTE_IDENT REMOTE_USER REQUEST_METHOD SCRIPT_NAME SERVER_NAME
#  SERVER_PORT SERVER_PROTOCOL SERVER_SOFTWARE
#
#  And anything that is of the format:
#
#  HTTP_* 
#  where * corresponse to an http header name
#
#  For example,
#  Conent-Length becomes HTTP_CONTENT_LENGTH
#
#  this is the format followed by:
#  python's wsgi
#  http://ken.coar.org/cgi/draft-coar-cgi-v11-03.txt
#
#  ruby's rack
#  http://rack.rubyforge.org/doc/files/SPEC.html
#
#  php's $_SERVER
#  http://php.net/manual/en/reserved.variables.server.php
#
#  and the spec:
#  http://ken.coar.org/cgi/draft-coar-cgi-v11-03.txt
#
#
#
#
#
#
#
#
class Rack::CgiProxy
  PROTOCOL_SUBSET = %w{
    AUTH_TYPE CONTENT_LENGTH CONTENT_TYPE GATEWAY_INTERFACE
    PATH_INFO PATH_TRANSLATED QUERY_STRING REMOTE_ADDR REMOTE_HOST
    AUTH_TYPE CONTENT_LENGTH CONTENT_TYPE GATEWAY_INTERFACE
    PATH_INFO PATH_TRANSLATED QUERY_STRING REMOTE_ADDR REMOTE_HOST
    REMOTE_IDENT REMOTE_USER REQUEST_METHOD SCRIPT_NAME SERVER_NAME
    SERVER_PORT SERVER_PROTOCOL SERVER_SOFTWARE
  }
  PROTOCOL_MATCH = /#{PROTOCOL_SUBSET.join("|")}|HTTP_*/

  def initialize(app, proxy_url)
    @app = app
    @proxy_url = proxy_url
  end

  # subclass and override to inject params into the request
  def user_info
    {}
  end

  def call(env)
    response  = RestClient.post(@proxy_url, request_info(env).merge(user_info).merge(env_info))   
    mods      = JSON.parse(response.body)

    STDOUT.puts "ENV",  env.inspect
    STDOUT.puts "MODS", mods

    mods.select { |k,v| k.match PROTOCOL_MATCH }.each do |key, value|
      env[key] = value
    end
    env['rack.input'] = StringIO.new(mods['body']) if mods['body']

    STDOUT.puts "ENV^", env.inspect

    @app.call(env)
  end

  private
  def env_info
    {'lang' => "ruby " + RUBY_VERSION} 
  end

  def request_info(env)
    env_vars = env.select { |k,v| k.match PROTOCOL_MATCH }
    env_vars.tap do |hash|
      if env['rack.input']
        hash.merge!(:body => env['rack.input'].read) 
        env['rack.input'].rewind
      end
    end
  end
end
