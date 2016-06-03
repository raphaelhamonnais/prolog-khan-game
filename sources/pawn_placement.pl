% ========================================================================================
% ========================================================================================
% ========================================================================================
% ===============              GERER LE DEPLACEMENT DES PIONS             ================
% ========================================================================================
% ========================================================================================
% ========================================================================================


% ========================================================================================
% ==============               PREDICATS DE CONTROLE BASIQUES              ===============
% ========================================================================================

/*
 * Prédicat qui permet de savoir si une cellule possède un pion ou pas
 */
cell_empty(X, Y) :- \+ pawn(X, Y, Pawn, Player).

/*
 * Prédicat qui vérifie que les coordonnées X et Y sont dans le plateau
 */
pawn_in_board(X,Y) :- X >= 1, X =<6, Y >= 1, Y =<6.

/*
 * Prédicat qui vérifie que les coordonnées X et Y sont sur les deux premières lignes en face du joueur
 * pour l'initialisation des pièces au début du jeu
 */
 pawn_in_initial_lines(X,Y,Player) :-
 		player1(Z), Player =:= Z, % dans le cas ou le Player = joueur 1 
 		X >= 5, X =< 6, Y >= 1, Y =< 6,!.
 pawn_in_initial_lines(X,Y,Player) :-
 		player2(Z), Player =:= Z, % dans le cas ou le Player = joueur 2
 		X >= 1, X =< 2, Y >= 1, Y =< 6,!.
/*
 * Prédicat qui renvoie vrai si la cellule ne contient pas déjà un pion appartenant au joueur Player
 */
no_pawn_player_in_cell(X,Y,Player) :-
		player1(Z), Player =:= Z, % dans le cas ou le Player = joueur 1 
		\+pawn(X,Y,_,Player),!.
no_pawn_player_in_cell(X,Y,Player) :-
		player2(Z), Player =:= Z, % dans le cas ou le Player = joueur 2
		\+pawn(X,Y,_,Player),!.




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
		no_pawn_player_in_cell(X,Y,Player),
		pawn_in_initial_lines(X,Y,Player).






/*
 * Permet de placer un pion : on supprime pour une case donnée les faits précédement enregistrés
 * et on rajouter dynamiquement le fait que le pion Pawn du joueur Player est sur la case X Y
 */
place_pawn(X, Y, Pawn, Player) :-
		retractall(pawn(X, Y, _, _)), % supprimer l'historique de la case
		asserta(pawn(X,Y,Pawn,Player)). % ajouter la pièce











% ========================================================================================
% ===========           DEPLACEMENT D'UNE PIECE AU COURS DU JEU             ==============
% ========================================================================================


/* Dans le cas où la pièce n'est pas sur le plateau */
ask_movement_to_player(Player) :-
		nl, write('Joueur '), write(Player), write(' --> '),
		write('Quelle pièce voulez-vous jouer ? (entrez son nom, S1, S2, ..., K)'), nl,
		read(Pawn),
		\+pawn(I, J, Pawn, Player), % dans le cas où la pièce n'est pas sur le plateau
		write('Vous ne pouvez pas jouer la pièce '), write(Pawn), write('. Recommencez SVP.'),
		ask_movement_to_player(Player).

ask_movement_to_player(Player) :-
		nl, write('Joueur '), write(Player), write(' --> '),
		write('Quelle pièce voulez-vous jouer ? (entrez son nom, S1, S2, ..., K)'), nl,
		read(Pawn),
		pawn(I, J, Pawn, Player), % dans le cas où la pièce est sur le plateau, on récupère les indices
		get_cell_value(I, J, CellValue) % récupérer la valeur de la case

		.



get_cell_value(X, Y, CellValue) :-
		activeBoard(Board),
		element_position_n(X, Board, Wanted_Line),
		element_position_n(Y, Wanted_Line, CellValue).













% ========================================================================================
% ===============               NE MARCHE PAS !!!!!!!              ================
% La fonction en soi marche, les write lorsqu'on est à un Range de 0 écrive bien la liste
% des coups effectivements possibles (avec des doublons car plusieurs chemins pour arriver)
% à une case mais pas moyen de récupérer la liste entière
% En plus le test de case vide ne doit pas être fait au début du déplacement car forcément
% on part de cette case, donc elle est pas vide
% ========================================================================================




callGenerate(X, Y, CellValue, Player, List) :-
	createPossibleMovesList(X,Y,CellValue,Player,[]).
	%setof(ListTmp, createPossibleMovesList(X,Y,CellValue,Player,[(X,Y)])).


createPossibleMovesList(X,Y,0, Player, Not_To_Consider) :-
		pawn_in_board(X,Y), % le pion doit rester dans le plateau
		\+member((X,Y),Not_To_Consider), % si le pion n'est pas membre des cases déjà visitées
		no_pawn_player_in_cell(X,Y,Player), % la cellule doit soit être vide, soit comporter un pion adverse, mais pas un pion du joueur
		write('--->  '), write('('), write(X), write(','), write(Y), write(')'),nl.

createPossibleMovesList(X,Y,0, Player, Not_To_Consider) :-
		X is X + 1,
		Y is Y + 0,
		pawn_in_board(X,Y), % le pion doit rester dans le plateau
		\+member((X,Y),Not_To_Consider), % si le pion n'est pas membre des cases déjà visitées
		no_pawn_player_in_cell(X,Y,Player), % la cellule doit soit être vide, soit comporter un pion adverse, mais pas un pion du joueur
		write('--->  '), write('('), write(X), write(','), write(Y), write(')'),nl.

createPossibleMovesList(X,Y,0, Player, Not_To_Consider) :-
		X is X + 0,
		Y is Y - 1,
		pawn_in_board(X,Y), % le pion doit rester dans le plateau
		\+member((X,Y),Not_To_Consider), % si le pion n'est pas membre des cases déjà visitées
		no_pawn_player_in_cell(X,Y,Player), % la cellule doit soit être vide, soit comporter un pion adverse, mais pas un pion du joueur
		write('--->  '), write('('), write(X), write(','), write(Y), write(')'),nl.

createPossibleMovesList(X,Y,0, Player, Not_To_Consider) :-
		X is X + 0,
		Y is Y + 1,
		pawn_in_board(X,Y), % le pion doit rester dans le plateau
		\+member((X,Y),Not_To_Consider), % si le pion n'est pas membre des cases déjà visitées
		no_pawn_player_in_cell(X,Y,Player), % la cellule doit soit être vide, soit comporter un pion adverse, mais pas un pion du joueur
		write('--->  '), write('('), write(X), write(','), write(Y), write(')'),nl.



createPossibleMovesList(X,Y,Range, Player, Not_To_Consider) :- % on donne juste Q comme liste de coups possibles car on ne veut pas le chemin intermédiaire entre la position de départ et celle d'arrivée
		Range > 0, % si la valeur de déplacement est supérieure à 1
		pawn_in_board(X,Y), % le pion doit rester dans le plateau
		\+member((X,Y),Not_To_Consider), % si le pion n'est pas membre des cases déjà visitées
		cell_empty(X,Y), % la cellule doit être vide car il est interdit de passer par dessus une pièce
		append([(X,Y)], Not_To_Consider, New_Not_To_Consider),
		New_X is X - 1, New_Y is Y + 0, New_Range is Range - 1,
		createPossibleMovesList(New_X,New_Y,New_Range,Player, New_Not_To_Consider).

createPossibleMovesList(X,Y,Range, Player, Not_To_Consider) :- % on donne juste Q comme liste de coups possibles car on ne veut pas le chemin intermédiaire entre la position de départ et celle d'arrivée
		Range > 0, % si la valeur de déplacement est supérieure à 1
		pawn_in_board(X,Y), % le pion doit rester dans le plateau
		\+member((X,Y),Not_To_Consider), % si le pion n'est pas membre des cases déjà visitées
		cell_empty(X,Y), % la cellule doit être vide car il est interdit de passer par dessus une pièce
		append([(X,Y)], Not_To_Consider, New_Not_To_Consider),
		New_X is X + 1, New_Y is Y + 0, New_Range is Range - 1,
		createPossibleMovesList(New_X,New_Y,New_Range,Player, New_Not_To_Consider).

createPossibleMovesList(X,Y,Range, Player, Not_To_Consider) :- % on donne juste Q comme liste de coups possibles car on ne veut pas le chemin intermédiaire entre la position de départ et celle d'arrivée
		Range > 0, % si la valeur de déplacement est supérieure à 1
		pawn_in_board(X,Y), % le pion doit rester dans le plateau
		\+member((X,Y),Not_To_Consider), % si le pion n'est pas membre des cases déjà visitées
		cell_empty(X,Y), % la cellule doit être vide car il est interdit de passer par dessus une pièce
		append([(X,Y)], Not_To_Consider, New_Not_To_Consider),
		New_X is X + 0, New_Y is Y - 1, New_Range is Range - 1,
		createPossibleMovesList(New_X,New_Y,New_Range,Player, New_Not_To_Consider).

createPossibleMovesList(X,Y,Range, Player, Not_To_Consider) :- % on donne juste Q comme liste de coups possibles car on ne veut pas le chemin intermédiaire entre la position de départ et celle d'arrivée
		Range > 0, % si la valeur de déplacement est supérieure à 1
		pawn_in_board(X,Y), % le pion doit rester dans le plateau
		\+member((X,Y),Not_To_Consider), % si le pion n'est pas membre des cases déjà visitées
		cell_empty(X,Y), % la cellule doit être vide car il est interdit de passer par dessus une pièce
		append([(X,Y)], Not_To_Consider, New_Not_To_Consider),
		New_X is X + 0, New_Y is Y + 1, New_Range is Range - 1,
		createPossibleMovesList(New_X,New_Y,New_Range,Player, New_Not_To_Consider).

createPossibleMovesList(_,_,_,_,_).