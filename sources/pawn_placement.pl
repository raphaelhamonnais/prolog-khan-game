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
cell_in_board(X,Y) :- X >= 1, X =<6, Y >= 1, Y =<6.

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


/*
 * Prédicat qui renvoie vrai si un joueur peut passer (sans finir) sur une case (droite, gauche, haut, bas)
 *		move_***(X,Y)
 */
 move_right(X, Y, NY) :- NY is Y+1, cell_in_board(X,NY), cell_empty(X,NY).
 move_left(X, Y, NY) :- NY is Y-1, cell_in_board(X,NY), cell_empty(X,NY).
 move_up(X, Y, NX) :- NX is X-1, cell_in_board(NX,Y), cell_empty(NX,Y).
 move_down(X, Y, NX) :- NX is X+1, cell_in_board(NX,Y), cell_empty(NX,Y).

 /*
 * Prédicat qui renvoie vrai si un joueur peut finir sur une case (droite, gauche, haut, bas)
 * 		finish_***(X,Y,Player,Cell) où Cell représente les coordonées de la case
 */
finish_right(X, Y, NY, Player) :- NY is Y+1, cell_in_board(X,NY), no_pawn_player_in_cell(X,NY, Player).
finish_left(X, Y, NY, Player) :- NY is Y-1, cell_in_board(X,NY), no_pawn_player_in_cell(X,NY, Player).
finish_up(X, Y, NX, Player) :- NX is X-1, cell_in_board(NX,Y), no_pawn_player_in_cell(NX,Y, Player).
finish_down(X, Y, NX, Player) :- NX is X+1, cell_in_board(NX,Y), no_pawn_player_in_cell(NX,Y, Player).

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





test_possible_moves() :-
		setof(L, possible_moves(3,3,1,2,[(3,3)],L), L),
		flatten(L,NL),
		clear_singletons_in_list(NL,NL1),
		write(NL1).

clear_singletons_in_list([],[]) :- !.
clear_singletons_in_list([(X,Y)|R], [(X,Y)|Q]) :- clear_singletons_in_list(R,Q),!.
clear_singletons_in_list([T|R], Q) :- clear_singletons_in_list(R,Q),!.



possible_moves(X, Y, Player, 1, AlreadySeens, [(X,NY)]) :-
		finish_right(X,Y, NY, Player), % si on peut finir vers la droite
		\+member((X,NY),AlreadySeens),
		write('finish_right.'), nl.
possible_moves(X, Y, Player, 1, AlreadySeens, [(X,NY)]) :-
		finish_left(X,Y, NY, Player), % si on peut finir vers la droite
		\+member((X,NY),AlreadySeens),
		write('finish_left.'), nl.
possible_moves(X, Y, Player, 1, AlreadySeens, [(X,NY)]) :-
		finish_up(X,Y, NX, Player), % si on peut finir vers la droite
		\+member((NX,Y),AlreadySeens),
		write('finish_up.'), nl.
possible_moves(X, Y, Player, 1, AlreadySeens, [(X,NY)]) :-
		finish_down(X,Y, NX, Player), % si on peut finir vers la droite
		\+member((NX,Y),AlreadySeens),
		write('finish_down.'), nl.


% possible de faire avec append aussi :
/*
possible_moves(X, Y, Player, 1, AlreadySeens, MoveList) :-
		finish_right(X,Y, NY, Player), % si on peut finir vers la droite
		\+member((X,NY),AlreadySeens),
		append([(X,NY)], [], MoveList),
		write('finish_right.'), nl.
possible_moves(X, Y, Player, 1, AlreadySeens, MoveList) :-
		finish_left(X,Y, NY, Player), % si on peut finir vers la droite
		\+member((X,NY),AlreadySeens),
		append([(X,NY)], [], MoveList),
		write('finish_left.'), nl.
possible_moves(X, Y, Player, 1, AlreadySeens, MoveList) :-
		finish_up(X,Y, NX, Player), % si on peut finir vers la droite
		\+member((NX,Y),AlreadySeens),
		append([(NX,Y)], [], MoveList),
		write('finish_up.'), nl.
possible_moves(X, Y, Player, 1, AlreadySeens, MoveList) :-
		finish_down(X,Y, NX, Player), % si on peut finir vers la droite
		\+member((NX,Y),AlreadySeens),
		append([(NX,Y)], [], MoveList),
		write('finish_down.'), nl.
*/



possible_moves(X, Y, Player, Range, AlreadySeens, MoveList) :-
		Range > 1,
		NewRange is Range-1,
		move_right(X,Y, NY), % si on peut finir vers la droite
		\+member((X,NY),AlreadySeens),
		append([(X,NY)], AlreadySeens, AlreadySeens_Tmp),
		write('move_right -> '),
		possible_moves(X, NY, Player, NewRange, AlreadySeens_Tmp, MoveList).

possible_moves(X, Y, Player, Range, AlreadySeens, MoveList) :-
		Range > 1,
		NewRange is Range-1,
		move_left(X,Y, NY), % si on peut finir vers la droite
		\+member((X,NY),AlreadySeens),
		append([(X,NY)], AlreadySeens, AlreadySeens_Tmp),
		write('move_left -> '),
		possible_moves(X, NY, Player, NewRange, AlreadySeens_Tmp, MoveList).

possible_moves(X, Y, Player, Range, AlreadySeens, MoveList) :-
		Range > 1,
		NewRange is Range-1,
		move_up(X,Y, NX), % si on peut finir vers la droite
		\+member((NX,Y),AlreadySeens),
		append([(NX,Y)], AlreadySeens, AlreadySeens_Tmp),
		write('move_up -> '),
		possible_moves(NX, Y, Player, NewRange, AlreadySeens_Tmp, MoveList).

possible_moves(X, Y, Player, Range, AlreadySeens, MoveList) :-
		Range > 1,
		NewRange is Range-1,
		move_down(X,Y, NX), % si on peut finir vers la droite
		\+member((NX,Y),AlreadySeens),
		append([(NX,Y)], AlreadySeens, AlreadySeens_Tmp),
		write('move_down -> '),
		possible_moves(NX, Y, Player, NewRange, AlreadySeens_Tmp, MoveList).

possible_moves(X, Y, Player, Range, AlreadySeens, MoveList).







% ========================================================================================
% ===============               NE MARCHE PAS !!!!!!!              ================
% La fonction en soi marche, les write lorsqu'on est à un Range de 0 écrive bien la liste
% des coups effectivements possibles (avec des doublons car plusieurs chemins pour arriver)
% à une case mais pas moyen de récupérer la liste entière
% En plus le test de case vide ne doit pas être fait au début du déplacement car forcément
% on part de cette case, donc elle est pas vide
% ========================================================================================

/*


callGenerate(X, Y, CellValue, Player, List) :-
	createPossibleMovesList(X,Y,CellValue,Player,[]).
	%setof(ListTmp, createPossibleMovesList(X,Y,CellValue,Player,[(X,Y)])).


createPossibleMovesList(X,Y,0, Player, Not_To_Consider) :-
		cell_in_board(X,Y), % le pion doit rester dans le plateau
		\+member((X,Y),Not_To_Consider), % si le pion n'est pas membre des cases déjà visitées
		no_pawn_player_in_cell(X,Y,Player), % la cellule doit soit être vide, soit comporter un pion adverse, mais pas un pion du joueur
		write('--->  '), write('('), write(X), write(','), write(Y), write(')'),nl.

createPossibleMovesList(X,Y,0, Player, Not_To_Consider) :-
		X is X + 1,
		Y is Y + 0,
		cell_in_board(X,Y), % le pion doit rester dans le plateau
		\+member((X,Y),Not_To_Consider), % si le pion n'est pas membre des cases déjà visitées
		no_pawn_player_in_cell(X,Y,Player), % la cellule doit soit être vide, soit comporter un pion adverse, mais pas un pion du joueur
		write('--->  '), write('('), write(X), write(','), write(Y), write(')'),nl.

createPossibleMovesList(X,Y,0, Player, Not_To_Consider) :-
		X is X + 0,
		Y is Y - 1,
		cell_in_board(X,Y), % le pion doit rester dans le plateau
		\+member((X,Y),Not_To_Consider), % si le pion n'est pas membre des cases déjà visitées
		no_pawn_player_in_cell(X,Y,Player), % la cellule doit soit être vide, soit comporter un pion adverse, mais pas un pion du joueur
		write('--->  '), write('('), write(X), write(','), write(Y), write(')'),nl.

createPossibleMovesList(X,Y,0, Player, Not_To_Consider) :-
		X is X + 0,
		Y is Y + 1,
		cell_in_board(X,Y), % le pion doit rester dans le plateau
		\+member((X,Y),Not_To_Consider), % si le pion n'est pas membre des cases déjà visitées
		no_pawn_player_in_cell(X,Y,Player), % la cellule doit soit être vide, soit comporter un pion adverse, mais pas un pion du joueur
		write('--->  '), write('('), write(X), write(','), write(Y), write(')'),nl.



createPossibleMovesList(X,Y,Range, Player, Not_To_Consider) :- % on donne juste Q comme liste de coups possibles car on ne veut pas le chemin intermédiaire entre la position de départ et celle d'arrivée
		Range > 0, % si la valeur de déplacement est supérieure à 1
		cell_in_board(X,Y), % le pion doit rester dans le plateau
		\+member((X,Y),Not_To_Consider), % si le pion n'est pas membre des cases déjà visitées
		cell_empty(X,Y), % la cellule doit être vide car il est interdit de passer par dessus une pièce
		append([(X,Y)], Not_To_Consider, New_Not_To_Consider),
		New_X is X - 1, New_Y is Y + 0, New_Range is Range - 1,
		createPossibleMovesList(New_X,New_Y,New_Range,Player, New_Not_To_Consider).

createPossibleMovesList(X,Y,Range, Player, Not_To_Consider) :- % on donne juste Q comme liste de coups possibles car on ne veut pas le chemin intermédiaire entre la position de départ et celle d'arrivée
		Range > 0, % si la valeur de déplacement est supérieure à 1
		cell_in_board(X,Y), % le pion doit rester dans le plateau
		\+member((X,Y),Not_To_Consider), % si le pion n'est pas membre des cases déjà visitées
		cell_empty(X,Y), % la cellule doit être vide car il est interdit de passer par dessus une pièce
		append([(X,Y)], Not_To_Consider, New_Not_To_Consider),
		New_X is X + 1, New_Y is Y + 0, New_Range is Range - 1,
		createPossibleMovesList(New_X,New_Y,New_Range,Player, New_Not_To_Consider).

createPossibleMovesList(X,Y,Range, Player, Not_To_Consider) :- % on donne juste Q comme liste de coups possibles car on ne veut pas le chemin intermédiaire entre la position de départ et celle d'arrivée
		Range > 0, % si la valeur de déplacement est supérieure à 1
		cell_in_board(X,Y), % le pion doit rester dans le plateau
		\+member((X,Y),Not_To_Consider), % si le pion n'est pas membre des cases déjà visitées
		cell_empty(X,Y), % la cellule doit être vide car il est interdit de passer par dessus une pièce
		append([(X,Y)], Not_To_Consider, New_Not_To_Consider),
		New_X is X + 0, New_Y is Y - 1, New_Range is Range - 1,
		createPossibleMovesList(New_X,New_Y,New_Range,Player, New_Not_To_Consider).

createPossibleMovesList(X,Y,Range, Player, Not_To_Consider) :- % on donne juste Q comme liste de coups possibles car on ne veut pas le chemin intermédiaire entre la position de départ et celle d'arrivée
		Range > 0, % si la valeur de déplacement est supérieure à 1
		cell_in_board(X,Y), % le pion doit rester dans le plateau
		\+member((X,Y),Not_To_Consider), % si le pion n'est pas membre des cases déjà visitées
		cell_empty(X,Y), % la cellule doit être vide car il est interdit de passer par dessus une pièce
		append([(X,Y)], Not_To_Consider, New_Not_To_Consider),
		New_X is X + 0, New_Y is Y + 1, New_Range is Range - 1,
		createPossibleMovesList(New_X,New_Y,New_Range,Player, New_Not_To_Consider).

createPossibleMovesList(_,_,_,_,_).


*/