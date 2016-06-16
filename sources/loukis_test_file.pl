
loukis_main():-
	include_sources(),
	reset_index(),
	reset_pawn(),
	reset_khan(),
	initBoard(),
	%ask_initial_pawns_placement(),
	place_pawn(1, 1, 'S1', 2),
	place_pawn(1, 2, 'S2', 2),
	place_pawn(1, 3, 'S3', 2),
	place_pawn(1, 4, 'S4', 2),
	place_pawn(1, 5, 'S5', 2),
	place_pawn(1, 6, 'K', 2),
	place_pawn(6, 1, 'S1', 1),
	place_pawn(6, 2, 'S2', 1),
	place_pawn(6, 3, 'S3', 1),
	place_pawn(6, 4, 'S4', 1),
	place_pawn(6, 5, 'S5', 1),
	place_pawn(6, 6, 'K', 1),
	dynamic_display_active_board(),
	%ask_movement_to_player(1),
	%joue(2, 1, 3),
	asserta(khan(1, 1)).


loukis_afficher([]). % condition d'arret
loukis_afficher([T|Q]):-
    write(T),nl,
    write(Q).

/*		TESTS
get_used_player_pawns(1, UsedPawnList), get_possible_pawn(1, UsedPawnList, PossiblePawnList), can_take_pawn(1, PossiblePawnList, 'K', JoueurAdverse, Move).

pawn(X, Y, 'S4', 1), get_khan_cell_value(Range), setof(ML, possible_moves(X, Y, 1, Range, [], ML), ML), flatten(ML, MoveList).

pawn(X, Y, 'S4', 1), get_khan_cell_value(Range), setof(ML, possible_moves(X, Y, 1, Range, [], ML), ML), flatten(ML, MoveList), is_that_pawn_in_range(MoveList, 'K', 2, I, J).

is_that_pawn_in_range([ (3, 4), (4, 3), (4, 5), (5, 2), (5, 6)], 'K', 2, X, Y).

pawn(X, Y, 'S1', 2), get_khan_cell_value(Range), setof(MLflat, possible_moves(X, Y, 2, Range, [], MLflat), MLflat), flatten(MLflat, ML), get_IAMoveFormat_from_PossibleMovesList(2, 1, X, Y, ML, MoveList).

*/