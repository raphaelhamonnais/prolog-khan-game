% placer les pions des joueurs pour tester d'autres fonctions



init_test_board():-
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
	dynamic_display_active_board().