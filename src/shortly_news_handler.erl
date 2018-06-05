-module(shortly_news_handler).
-export([init/2,
         websocket_init/1,
         websocket_handle/2,
         websocket_info/2]).

init(Req, State) ->
  {cowboy_websocket, Req, State}.

websocket_init(State) ->
    pg2:join(ws_connections, self()),
    {ok, State}.

websocket_handle(InFrame, State) ->
  {ok, State}.

websocket_info({new_url, Url, Hash}, State) ->
  Msg = erlang:iolist_to_binary([<<"url: ">>, Url, <<", hash: ">>, Hash]),
  {reply, {text, Msg}, State}.
