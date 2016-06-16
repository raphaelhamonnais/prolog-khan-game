
include_sources() :-
	[useful_functions],
	[facts_dynamic],
	[facts_static],
	[board_display],
	[init_board],
	[pawn_placement],
	[pawn_mouvement],
	[game_loop],
	[tests_file],
	[ia].

main() :- 
	include_sources(), % inclure tous les fichiers
	reset_all_dynamic_facts(), % supprimer tous les faits dynamiques
	initBoard(), % afficher le plateau initial avec choix de la disposition
	ask_initial_pawns_placement(), % demander aux joueurs de placer leurs pions
	%init_test_board(),
	launch_game().



launch_game :-
	write('Entrez 1 pour jouer contre la machine, 2 pour jouer à deux joueurs.'),
	read(Choice),
	launch_specific_game(Choice),!.



launch_specific_game(1) :- human_vs_machine_launch_game(),!.
launch_specific_game(2) :- human_vs_human_launch_game(),!.
launch_specific_game(_) :- 
	writeInRed('Mauvaise saisie. Recommencez'),
	nl, launch_game(),!.