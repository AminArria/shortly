-module(shortly_rest_handler).

-export ([init/2,
          allowed_methods/2,
          resource_exists/2,
          content_types_accepted/2,
          content_types_provided/2,
          shortly_to_json/2,
          shortly_post_url/2]).

init(Req, State) ->
  {cowboy_rest, Req, State}.

allowed_methods(Req, State) ->
  {[<<"GET">>, <<"POST">>], Req, State}.

resource_exists(Req = #{method := <<"GET">>}, State0) ->
  Hash = erlang:iolist_to_binary(lists:join(<<"/">>, cowboy_req:path_info(Req))),
  case shortly_shortener:get_long_url(Hash) of
    {ok, LongURL} ->
      State = State0#{url => LongURL, hash => Hash},
      {true, Req, State};
    error ->
      {stop, cowboy_req:reply(404, Req), State0}
  end;
resource_exists(Req = #{method := <<"POST">>}, State) ->
  {true, Req, State}.

content_types_accepted(Req, State) ->
  {[{'*', shortly_post_url}], Req, State}.

content_types_provided(Req, State) ->
  {[{<<"application/json">>, shortly_to_json}], Req, State}.

shortly_to_json(Req, State) ->
  Json = "{url: \"~s\", hash: \"~s\"}",
  Body = io_lib:format(Json, [maps:get(url, State), maps:get(hash, State)]),
  {Body, Req, State}.

shortly_post_url(Req0, State) ->
  Url = erlang:iolist_to_binary(lists:join(<<"/">>, cowboy_req:path_info(Req0))),
  Hash = shortly_shortener:save_url(Url),
  Req = cowboy_req:reply(200, #{
    <<"content-type">> => <<"text/plain">>
  }, Hash, Req0),
  {true, Req, State}.
