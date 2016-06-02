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

ask_one_player_initial_pawns_placement(Player, [PawnsList_Head|Q]) :-
		write('Placer le pion '), write(PawnsList_Head), nl,
		write('Ligne : '), read(X), nl, % demander et lire l'indice de la ligne
		write('Colonne : '), read(Y), nl, % demander et lire l'indice de la colonne
		place_pawn(X, Y, PawnsList_Head, Player),
		dynamic_display_active_board(),
		ask_one_player_initial_pawns_placement(Player, Q).
ask_one_player_initial_pawns_placement(Player, []).

/*
 * Prédicat qui permet de savoir si une cellule possède un pion ou pas
 */
is_cell_empty(X, Y) :- \+ pawn(X, Y, Pawn, Player).


place_pawn(X, Y, Pawn, Player) :-
		retractall(pawn(X, Y, _, _)), % supprimer l'historique de la case
		asserta(pawn(X,Y,Pawn,Player)). % ajouter la pièce

		
