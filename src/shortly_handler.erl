-module(shortly_handler).

-export ([init/2]).

init(Req0=#{method := <<"POST">>}, State) ->
  Short_url = shortly_shortener:save_url(cowboy_req:path_info(Req0)),
  Req = cowboy_req:reply(200, #{
    <<"content-type">> => <<"text/plain">>
  }, Short_url, Req0),
  {ok, Req, State};

init(Req0=#{method := <<"GET">>}, State) ->
  case shortly_shortener:get_long_url(cowboy_req:path_info(Req0)) of
    {ok, Long_url} ->
      Req = cowboy_req:reply(303, #{
        <<"Location">> => Long_url
      }, Req0);
    error ->
      Req = cowboy_req:reply(404, Req0)
  end,
  {ok, Req, State}.
