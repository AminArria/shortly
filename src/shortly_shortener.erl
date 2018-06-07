-module(shortly_shortener).

-export([save_url/1,
         get_long_url/1
        ]).


save_url(Url) ->
  Hash = hash_url(Url),
  shortly_db:save_url(Hash, Url),
  send_notifications(Url, Hash),
  Hash.

get_long_url(Hash) ->
  case shortly_db:get_url(Hash) of
    [] ->
      error;
    [{Hash, Url}] ->
      case http_uri:parse(Url) of
        {ok, _} ->
          {ok, Url};
        {error, _} ->
          {ok, [<<"http://">> | Url]}
      end
  end.

hash_url(Url) ->
  Hash = crypto:hash(md5, Url),
  base64:encode(Hash).

send_notifications(Url, Hash) ->
  syn:publish(ws_connections, {new_url, Url, Hash}).
