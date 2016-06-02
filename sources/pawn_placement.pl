is_cell_empty(X, Y) :- \+ pawn(X, Y, Pawn, Player).

place_pawn(X, Y, Pawn, Player):-	is_cell_empty(X, Y).