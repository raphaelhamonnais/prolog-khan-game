writeWithPlayerColor(X, Player) :- 	Player = 1,
									ansi_format([bold,fg(red)], '~w', [X]),!.
writeWithPlayerColor(X, Player) :- 	Player = 2,
									ansi_format([bold,fg(green)], '~w', [X]),!.
writeWithPlayerColor(X, Player) :- 	ansi_format([bold,fg(white)], '~w', [X]),!.




% removeHeadOfList(HeadWanted, List, NewListWithoutHead)
removeHeadOfList(T, [T|Q], Q).

% copy list L in list R
copy(L,R) :- accCp(L,R).
accCp([],[]).
accCp([H|T1],[H|T2]) :- accCp(T1,T2).