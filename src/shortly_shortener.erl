-module(shortly_shortener).

-export([save_url/1,
         get_long_url/1
        ]).

save_url(Url) ->
  Hash = hash_url(Url),
  ets:insert(urls, {Hash, Url}),
  Hash.

get_long_url(Hash) ->
  case ets:lookup(urls, Hash) of
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
