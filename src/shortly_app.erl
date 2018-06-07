%%%-------------------------------------------------------------------
%% @doc shortly public API
%% @end
%%%-------------------------------------------------------------------

-module(shortly_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1, install/1]).

-record(shortly_urls, {hash, url}).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    syn:init(),
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

install(Nodes) ->
    mnesia:stop(),
    rpc:multicall(Nodes, application, stop, [mnesia]),
    ok = mnesia:create_schema([node() | Nodes]),
    mnesia:start(),
    rpc:multicall(Nodes, application, start, [mnesia]),
    mnesia:create_table(shortly_urls,
      [{attributes, record_info(fields, shortly_urls)},
       {type, set},
       {ram_copies, Nodes}]),
    mnesia:stop().

%%====================================================================
%% Internal functions
%%====================================================================
