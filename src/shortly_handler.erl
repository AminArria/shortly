-module(shortly_handler).

-export ([init/2]).

init(Req0=#{method := <<"POST">>}, State) ->
  Url = erlang:iolist_to_binary(lists:join(<<"/">>, cowboy_req:path_info(Req0))),
  Short_url = shortly_shortener:save_url(Url),
  Req = cowboy_req:reply(200, #{
    <<"content-type">> => <<"text/plain">>
  }, Short_url, Req0),
  {ok, Req, State};

init(Req0=#{method := <<"GET">>}, State) ->
  Hash = erlang:iolist_to_binary(lists:join(<<"/">>, cowboy_req:path_info(Req0))),
  case shortly_shortener:get_long_url(Hash) of
    {ok, Long_url} ->
      Req = cowboy_req:reply(303, #{
        <<"Location">> => Long_url
      }, Req0);
    error ->
      Req = cowboy_req:reply(404, Req0)
  end,
  {ok, Req, State}.
