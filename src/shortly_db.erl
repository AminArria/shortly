-module(shortly_db).

-export([save_url/2,
         get_url/1]).

-record(shortly_urls, {hash, url}).


save_url(Hash, Url) ->
  mnesia:activity(transaction, fun() ->
      mnesia:write(#shortly_urls{hash=Hash, url=Url})
    end).

get_url(Hash) ->
  Result = mnesia:activity(transaction, fun() ->
      mnesia:read(shortly_urls, Hash)
    end),
  case Result of
    [] ->
      [];
    [#shortly_urls{hash=Hash, url=Url}] ->
      [{Hash, Url}]
  end.
