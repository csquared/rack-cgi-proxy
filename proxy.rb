require 'bundler'
Bundler.require
require 'sinatra'

# http://ken.coar.org/cgi/draft-coar-cgi-v11-03.txt
post '/:id' do
  STDOUT.puts "PARAMS: #{params.inspect}"

  # GET /?*head* => HEAD request
  if params['QUERY_STRING'].include? 'head' # being lazy here - should check actual params
    #{:REQUEST_METHOD => 'HEAD', :body => ''}.to_json
    {}.to_json
  # GET /?*post=query* => POST request, query string as post body
  elsif params['QUERY_STRING'].include? 'post=query'
    puts "making post with a body"
    {:REQUEST_METHOD => 'POST', :body => params['QUERY_STRING']}.to_json
  # GET /?*post=sup* => POST request, known body
  elsif params['QUERY_STRING'].include? 'post=sup'
    puts "changing post body with"
    {:REQUEST_METHOD => 'POST', :QUERY_STRING => 'ho=la', :body => "sup=dude"}.to_json
  # GET /?*post=* => POST request, don't touch body
  elsif params['QUERY_STRING'].include? 'post='
    puts "making post"
    {:REQUEST_METHOD => 'POST'}.to_json
  # GET /?*delete=* => DELETE request with known query string and body
  elsif params['QUERY_STRING'].include? 'delete='
    puts "changing post body"
    {:REQUEST_METHOD => 'DELETE', :QUERY_STRING => 'ho=la', :body => "sup=dude"}.to_json
  # GET /?*put=true=* => PUT request that removes its trigger param from request
  elsif params['QUERY_STRING'].include? 'put=true'
    puts "making put"
    { :REQUEST_METHOD => 'PUT', 
      :QUERY_STRING => params['QUERY_STRING'].gsub(/put=true/,'')}.to_json
  # don't change anything -> perhaps this should just be a status code?
  else
    puts "nothing"
    {}.to_json
  end
end
