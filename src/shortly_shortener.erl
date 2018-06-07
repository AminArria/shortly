-module(shortly_shortener).

-export([save_url/1,
         get_long_url/1
        ]).

-record(shortly_urls, {hash, url}).

save_url(Url) ->
  Hash = hash_url(Url),
  mnesia:activity(transaction, fun() ->
      mnesia:write(#shortly_urls{hash=Hash, url=Url})
    end),
  send_notifications(Url, Hash),
  Hash.

get_long_url(Hash) ->
  Result = mnesia:activity(transaction, fun() ->
      mnesia:read(shortly_urls, Hash)
    end),
  case Result of
    [] ->
      error;
    [#shortly_urls{hash=Hash, url=Url}] ->
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
  lists:foreach(fun(Pid) ->
    Pid ! {new_url, Url, Hash}
  end, pg2:get_members(ws_connections)).
