player1(1).
player2(2).
pawnList(['Sbire1', 'Sbire2', 'Sbire3', 'Sbire4', 'Sbire5', 'Khalessi']).

include_sources() :-
	[useful_functions],
	[init_board],
	[dynamic_board_display],
	[pawn_placement].

main() :- 
	include_sources(),
	initBoard(),
	init_dynamic_fact(),				%temporaire tant que l'on ne positionne pas les pièces
	activeBoard(BOARD),
	dynamic_display(BOARD).