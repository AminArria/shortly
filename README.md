# Shortly
=====

An URL shortener using Erlang and Cowboy

## Using
You can start a shell with the application running by executing `make`.

Afterwards you can simply try it:
```
$> curl -i -X POST localhost:8080/http://learnyousomeerlang.com/ets
HTTP/1.1 200 OK
content-length: 24
content-type: text/plain
date: Fri, 01 Jun 2018 20:24:31 GMT
server: Cowboy

eJoBVL8Y/ORXRo44phS+Gg==

$> curl -i -X GET localhost:8080/eJoBVL8Y/ORXRo44phS+Gg==
HTTP/1.1 303 See Other
Location: http://learnyousomeerlang.com/ets
content-length: 0
date: Fri, 01 Jun 2018 20:24:40 GMT
server: Cowboy
```
