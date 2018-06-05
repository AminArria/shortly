-module(shortly_news_handler).
-export([init/2,
         websocket_init/1,
         websocket_handle/2,
         websocket_info/2]).

init(Req, State) ->
  {cowboy_websocket, Req, State}.


  % curl --include \
  %      --no-buffer \
  %      --header "Connection: Upgrade" \
  %      --header "Upgrade: websocket" \
  %      --header "Host: localhost:8080" \
  %      --header "Origin: http://localhost:8080" \
  %      --header "Sec-WebSocket-Key: SGVsbG8sIHdvcmxkIQ==" \
  %      --header "Sec-WebSocket-Version: 13" \
  % http://localhost:8080/news

websocket_init(State) ->
    pg2:join(ws_connections, self()),
    {ok, State}.

websocket_handle(InFrame, State) ->
  {ok, State}.

websocket_info({new_url, Url, Hash}, State) ->
  Msg = erlang:iolist_to_binary([<<"url: ">>, Url, <<", hash: ">>, Hash]),
  {reply, {text, Msg}, State}.
