-module(gpioapi_callback).
-export([handle/2, handle_event/3]).

-include_lib("elli/include/elli.hrl").

-behaviour(elli_handler).

bitstring2int(V) -> list_to_integer(bitstring_to_list(V)).

registerpin(P,D) ->
      memory:init(),
      L = gpio:init(bitstring2int(P), binary_to_atom(D, latin1)),
      memory:insert(P,L),
      list_to_bitstring("Registering PIN" ++ bitstring_to_list(P) ++ " as " ++ bitstring_to_list(D) ++ ".").

writepin(P,V) ->
      L = memory:select(P),
      gpio:write(L, bitstring2int(V)),
      list_to_bitstring("WRITE " ++ bitstring_to_list(V) ++ " into PIN" ++ bitstring_to_list(P) ++ ".").

readpin(P) ->
      L = memory:select(P),
      V = gpio:read(L),
      list_to_bitstring("READ from PIN" ++ bitstring_to_list(P) ++ " returned value " ++ V ++ ".").

closepin(P) ->
      L = memory:select(P),
      gpio:stop(L),
      list_to_bitstring("unregistered PIN" ++ bitstring_to_list(P) ++ ".").

handle(Req, _Args) ->
      handle(Req#req.method, elli_request:path(Req), Req).

handle('GET',[<<"register">>, PIN, DIRECTION], _Req) ->
      {ok, [], registerpin(PIN,DIRECTION) };

handle('GET',[<<"write">>, PIN, VALUE], _Req) ->
      {ok, [], writepin(PIN,VALUE) };

handle('GET',[<<"read">>, PIN], _Req) ->
      {ok, [], readpin(PIN) };

handle('GET',[<<"unregister">>, PIN], _Req) ->
      {ok, [], closepin(PIN) };

handle(_, _, _Req) ->
      {404, [], <<"Not Found">>}.

handle_event(_Event, _Data, _Args) ->
      ok.
