%%%-------------------------------------------------------------------
%% @doc shortly public API
%% @end
%%%-------------------------------------------------------------------

-module(shortly_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    pg2:create(ws_connections),
    ets:new(urls, [set, named_table, public]),
    {ok, Port} = application:get_env(shortly, port),
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/http/[...]", shortly_handler, #{}},
            {"/rest/[...]", shortly_rest_handler, #{}},
            {"/news", shortly_news_handler, #{}}
        ]}
    ]),
    cowboy:start_clear(http,
        [{port, Port}],
        #{env => #{dispatch => Dispatch}}
    ).


%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
