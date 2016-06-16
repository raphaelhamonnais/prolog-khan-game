% ========================================================================================
% ========================================================================================
% ========================================================================================
% ===============          GERER LE PLACEMENT INITIAL DES PIONS             ==============
% ========================================================================================
% ========================================================================================
% ========================================================================================


% ========================================================================================
% ==============          PREDICATS UTILES AU PLACEMENT DES PIECES              ==========
% ========================================================================================




/*
 * Predicat de controle pour le placement des pions au debut.
 * Le joueur 1 doit les placer en bas, le joueur 2 en haut, et la case doit etre vide.
 */
initial_pawn_placement_correct(Player, X, Y) :-
		no_pawn_player_in_cell(X,Y,Player),
		pawn_in_initial_lines(X,Y,Player).


/*
 * Predicat qui verifie que les coordonnees X et Y sont sur les deux premieres lignes en face du joueur
 * pour l'initialisation des pieces au debut du jeu
 */
 pawn_in_initial_lines(X,Y,Player) :-
 		player1(Z), Player =:= Z, % dans le cas ou le Player = joueur 1 
 		X >= 5, X =< 6, Y >= 1, Y =< 6,!.
 pawn_in_initial_lines(X,Y,Player) :-
 		player2(Z), Player =:= Z, % dans le cas ou le Player = joueur 2
 		X >= 1, X =< 2, Y >= 1, Y =< 6,!.





% ========================================================================================
% ===============               PLACEMENT DES PIONS AU DEBUT              ================
% ========================================================================================





% ======= PLACEMENT INITIAL DES PIONS  =======

/*
 * Demander aux deux joueurs de placer tous leurs pions
 */

ask_initial_pawns_placement() :-
		player1(Player_1),player2(Player_2), % avoir les valeurs numeriques correspondantes au joueur 1 et 2
		get_unused_player_pawns(Player_1, UnusedPawnList_Player_1), % avoir la liste des pions non places du joueur 1
		get_unused_player_pawns(Player_2, UnusedPawnList_Player_2), % avoir la liste des pions non places du joueur 2
		nl,nl, write('----------  Placement des pions  ----------'),
		nl, write('Joueur 1, a vous'), nl,
		ask_one_player_initial_pawns_placement(Player_1, UnusedPawnList_Player_1),
		nl, write('Joueur 2, a vous'),
		ask_one_player_initial_pawns_placement(Player_2, UnusedPawnList_Player_2),
		nl, nl, write('Le plateau est maintenant pret pour jouer :'),
		nl, nl,
		dynamic_display_active_board().


/*
 * Demander a un joueur precis de placer tout les pions situes dans la liste [PawnsList_Head|Q]
 */
ask_one_player_initial_pawns_placement(Player, [PawnsList_Head|Q]) :-
		nl, write('Placer le pion '), write(PawnsList_Head), nl,
		write('Ligne : '), read(X), % demander et lire l'indice de la ligne
		write('Colonne : '), read(Y), nl, % demander et lire l'indice de la colonne

		(initial_pawn_placement_correct(Player,X,Y)
			-> 	place_pawn(X, Y, PawnsList_Head, Player),
				dynamic_display_active_board(),
				ask_one_player_initial_pawns_placement(Player, Q)

			; 	writeInRed('Placement illegal, recommencez.'),
				ask_one_player_initial_pawns_placement(Player, [PawnsList_Head|Q])
		).
ask_one_player_initial_pawns_placement(Player, []).





