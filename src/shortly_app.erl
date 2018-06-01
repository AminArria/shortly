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
    ets:new(urls, [set, named_table, public]),
    Dispatch = cowboy_router:compile([
        {'_', [{"/[...]", shortly_handler, []}]}
    ]),
    {ok, _} = cowboy:start_clear(http,
        [{port, 8080}],
        #{env => #{dispatch => Dispatch}}
    ).
    % shortly_sup:start_link().


%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
