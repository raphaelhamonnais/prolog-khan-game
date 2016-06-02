
include_sources() :-
	[useful_functions],
	[facts_dynamic],
	[facts_static],
	[board_display],
	[init_board],
	[pawn_placement].

main() :- 
	include_sources(), % inclure tous les fichiers
	reset_all_dynamic_facts(), % supprimer tous les faits dynamiques
	initBoard(). % afficher le plateau initial avec choix de la disposition
	% demander aux joueurs de placer leurs pions
	% lancer jeu