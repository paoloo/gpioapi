-module(memory).
-export([init/0, insert/2, select/1, delete/1]).

-record(gpins, {pin, ref}).

init() ->
      mnesia:create_schema([node()]),
      mnesia:start(),
      mnesia:create_table(gpins, [{ram_copies, [node()] }, {attributes, record_info(fields,gpins)}]).

insert(Pin, Ref) ->
      Fun = fun() ->
            mnesia:write(#gpins{ pin=Pin, ref=Ref })
      end,
      mnesia:transaction(Fun).

select(Pin) ->
      Fun = fun() ->
            mnesia:read({gpins, Pin})
      end,
      {atomic, [Row]}=mnesia:transaction(Fun),
      Row#gpins.ref.

delete(Pin) ->
      Fun = fun() ->
           mnesia:delete({gpins, Pin})
      end,
      mnesia:transaction(Fun).
