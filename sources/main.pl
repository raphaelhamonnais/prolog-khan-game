
include_sources() :-
	[useful_functions],
	[facts_dynamic],
	[facts_static],
	[board_display],
	[init_board],
	[pawn_placement],
	[tests_file].

main() :- 
	include_sources(), % inclure tous les fichiers
	reset_all_dynamic_facts(), % supprimer tous les faits dynamiques
	initBoard(), % afficher le plateau initial avec choix de la disposition
	%ask_initial_pawns_placement(), % demander aux joueurs de placer leurs pions
	init_test_board(), % initialisation des pions pour test
	human_vs_human_launch_game().
	% lancer jeu