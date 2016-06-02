% ========================================================================================
% ========================================================================================
% ========================================================================================
% ===============              GERER LE DEPLACEMENT DES PIONS             ================
% ========================================================================================
% ========================================================================================
% ========================================================================================






% ========================================================================================
% ===============               PLACEMENT DES PIONS AU DEBUT              ================
% ========================================================================================


/*
 * Demander aux deux joueurs de placer tous leurs pions
 */

ask_initial_pawns_placement() :-
		player1(Player_1),player2(Player_2), % avoir les valeurs numériques correspondantes au joueur 1 et 2
		get_unused_player_pawns(Player_1, UnusedPawnList_Player_1), % avoir la liste des pions non placés du joueur 1
		get_unused_player_pawns(Player_2, UnusedPawnList_Player_2), % avoir la liste des pions non placés du joueur 2
		nl,nl, write('----------  Placement des pions  ----------'),
		nl, write('Joueur 1, à vous'), nl,
		ask_one_player_initial_pawns_placement(Player_1, UnusedPawnList_Player_1),
		nl, write('Joueur 2, à vous'),
		ask_one_player_initial_pawns_placement(Player_2, UnusedPawnList_Player_2),
		nl, nl, write('Le plateau est maintenant prêt pour jouer :'),
		nl, nl,
		dynamic_display_active_board().


/*
 * Demander à un joueur précis de placer tout les pions situés dans la liste [PawnsList_Head|Q]
 */
ask_one_player_initial_pawns_placement(Player, [PawnsList_Head|Q]) :-
		nl, write('Placer le pion '), write(PawnsList_Head), nl,
		write('Ligne : '), read(X), % demander et lire l'indice de la ligne
		write('Colonne : '), read(Y), nl, % demander et lire l'indice de la colonne

		(initial_pawn_placement_correct(Player,X,Y)
			-> 	place_pawn(X, Y, PawnsList_Head, Player),
				dynamic_display_active_board(),
				ask_one_player_initial_pawns_placement(Player, Q)

			; 	write('Placement illegal, recommencez.'),
				ask_one_player_initial_pawns_placement(Player, [PawnsList_Head|Q])
		).
ask_one_player_initial_pawns_placement(Player, []).


/*
 * Prédicat de controle pour le placement des pions au début.
 * Le joueur 1 doit les placer en bas, le joueur 2 en haut, et la case doit etre vide.
 */

initial_pawn_placement_correct(Player, X, Y) :-
	player1(Z), Player = Z,
	cell_empty(X, Y),
	X >= 5, X =< 6, Y >= 1, Y =< 6.
initial_pawn_placement_correct(Player, X, Y) :-
	player2(Z), Player = Z,
	cell_empty(X, Y),
	X >= 1, X =< 2, Y >= 1, Y =< 6.



/*
 * Prédicat qui permet de savoir si une cellule possède un pion ou pas
 */
cell_empty(X, Y) :- \+ pawn(X, Y, Pawn, Player).



/*
 * Permet de placer un pion : on supprime pour une case donnée les faits précédement enregistrés
 * et on rajouter dynamiquement le fait que le pion Pawn du joueur Player est sur la case X Y
 */
place_pawn(X, Y, Pawn, Player) :-
		retractall(pawn(X, Y, _, _)), % supprimer l'historique de la case
		asserta(pawn(X,Y,Pawn,Player)). % ajouter la pièce

		
