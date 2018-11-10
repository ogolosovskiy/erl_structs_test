-module(test4).
-export([main/0, count_occurrence1/1, count_occurrence2/1, count_occurrence3/1]).


count_occurrence1(L) ->
  Inc = fun(X) -> X + 1 end,
  Update = fun(X, Map) -> maps:update_with(X, Inc, 1, Map) end,
  maps:to_list(lists:foldl(Update, #{}, L)).

count2([], Result, PrevH, Repeat) ->
  [{PrevH, Repeat} | Result];
count2([CurH | Tail], Result, PrevH, Repeat) ->
  case CurH of
    PrevH -> count2(Tail, Result, CurH, Repeat + 1);
    _ -> count2(Tail, [{PrevH, Repeat} | Result], CurH, 1)
  end.
count_occurrence2(L) ->
  Sl = lists:sort(L),
  [Hd | Tl] = Sl,
  count2(Tl, [], Hd, 1).

count_occurrence3(L) ->
  Update = fun(X, Dict) -> dict:update_counter(X, 1, Dict) end,
  dict:to_list(lists:foldl(Update, dict:new(), L)).

main() ->

  L = [rand:uniform(10) || _ <- lists:seq(1, 100000)],

  {Occ1, _} =  timer:tc(test4, count_occurrence1, [L]),
  io:format("count_occurrence1 (map): ~w microseconds ~n", [Occ1]),

  {Occ2, _} =  timer:tc(test4, count_occurrence2, [L]),
  io:format("count_occurrence2 (lists:sort): ~w microseconds ~n", [Occ2]),

  {Occ3, _} =  timer:tc(test4, count_occurrence3, [L]),
  io:format("count_occurrence3 (dict:update_counter): ~w microseconds ~n", [Occ3]),

  erlang:halt(0).

