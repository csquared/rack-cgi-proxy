#!/bin/sh
some_silence="....."
echo $1
echo "GET /?*head* => HEAD request"
echo "GET $1?head=true" 
curl "$1?head=true" 
echo $some_silence
echo "GET /?*post=query* => POST request, query string as post body"
echo "GET $1?post=query&foo=bar&jay=zee"
curl "$1?post=query&foo=bar&jay=zee"
echo $some_silence
echo "# GET /?*post=sup* => POST request, known body, sets QUERY_STRING for fun as well"
echo "GET $1?post=sup&foo=bar&jay=zee"
curl "$1?post=sup&foo=bar&jay=zee"
echo $some_silence
echo "GET /?*post=* => POST request, don't touch body"
echo "GET $1?post=query&foo=bar&jay=zee"
curl "$1?post=query&foo=bar&jay=zee"
echo $some_silence
echo "GET /?*delete=* => DELETE request with known query string and body"
echo "GET $1?delete=query&foo=bar&jay=zee"
curl "$1?delete=query&foo=bar&jay=zee"
echo $some_silence
echo "GET /?*put=true=* => PUT request that removes its trigger param from request"
echo "GET $1?put=true&foo=bar&jay=zee"
curl "$1?put=true&foo=bar&jay=zee"
echo $some_silence
echo "don't change anything -> perhaps this should just be a status code?"
echo "GET $1/?foo=bar"
curl "$1/?foo=bar"
echo $some_silence
echo "GET $1/index.php?foo=bar"
curl "$1/index.php?foo=bar"
echo $some_silence
echo "GET $1/index?foo=bar"
curl "$1/index?foo=bar"
echo $some_silence
echo "-d \"foo=bar\" $1"
curl -d "foo=bar" $1
echo $some_silence
echo "--header \"X-Foo: bar\" $1"
curl --header "X-Foo: bar" $1
echo $some_silence
