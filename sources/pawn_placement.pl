% ========================================================================================
% ========================================================================================
% ========================================================================================
% ===============              GERER LE DEPLACEMENT DES PIONS             ================
% ========================================================================================
% ========================================================================================
% ========================================================================================


% ========================================================================================
% ==============          PREDICATS UTILES AU PLACEMENT DES PIECES              ==========
% ========================================================================================

/*
 * Prédicat qui permet de savoir si une cellule possède un pion ou pas
 */
cell_empty(X, Y) :- \+ pawn(X, Y, Pawn, Player).



/*
 * Prédicat qui permet de savoir si une case de coordonnées X,Y est bien dans la liste de cases MoveList
 */
check_good_coordonates(X,Y,MoveList) :-
		member_one_occurence((X,Y),MoveList).

				% ===============================

/*
 * Prédicat qui vérifie que les coordonnées X et Y sont dans le plateau
 */
cell_in_board(X,Y) :- X >= 1, X =<6, Y >= 1, Y =<6.

				% ===============================

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

				% ===============================

/*
 * Prédicat qui renvoie vrai si la cellule ne contient pas déjà un pion appartenant au joueur Player
 */
no_pawn_player_in_cell(X,Y,Player) :-
		player1(Z), Player =:= Z, % dans le cas ou le Player = joueur 1 
		\+pawn(X,Y,_,Player),!.
no_pawn_player_in_cell(X,Y,Player) :-
		player2(Z), Player =:= Z, % dans le cas ou le Player = joueur 2
		\+pawn(X,Y,_,Player),!.

				% ===============================

/*
 * Prédicat qui renvoie vrai si un joueur peut passer (sans finir) sur une case (droite, gauche, haut, bas)
 *		move_***(X,Y)
 */
 move_right(X, Y, NY) :- NY is Y+1, cell_in_board(X,NY), cell_empty(X,NY).
 move_left(X, Y, NY) :- NY is Y-1, cell_in_board(X,NY), cell_empty(X,NY).
 move_up(X, Y, NX) :- NX is X-1, cell_in_board(NX,Y), cell_empty(NX,Y).
 move_down(X, Y, NX) :- NX is X+1, cell_in_board(NX,Y), cell_empty(NX,Y).

				% ===============================

 /*
 * Prédicat qui renvoie vrai si un joueur peut finir sur une case (droite, gauche, haut, bas)
 * 		finish_***(X,Y,Player,Cell) où Cell représente les coordonées de la case
 */
finish_right(X, Y, NY, Player) :- NY is Y+1, cell_in_board(X,NY), no_pawn_player_in_cell(X,NY, Player).
finish_left(X, Y, NY, Player) :- NY is Y-1, cell_in_board(X,NY), no_pawn_player_in_cell(X,NY, Player).
finish_up(X, Y, NX, Player) :- NX is X-1, cell_in_board(NX,Y), no_pawn_player_in_cell(NX,Y, Player).
finish_down(X, Y, NX, Player) :- NX is X+1, cell_in_board(NX,Y), no_pawn_player_in_cell(NX,Y, Player).

				% ===============================

/*
 * Prédicat qui renvoie la valeur d'une case d'indice X et Y
 */
get_cell_value(X, Y, CellValue) :-
		activeBoard(Board),
		element_position_n(X, Board, Wanted_Line),
		element_position_n(Y, Wanted_Line, CellValue),!.


/*
 * Prédicat qui renvoie la valeur de la case où est placé le khan
 */
get_khan_cell_value(CellValue) :-
		khan(X,Y),
		get_cell_value(X, Y, CellValue),!.


/*
 * Prédicat qui renvoie vrai si la case X,Y a la même valeur que celle du khan
 */
cell_has_same_value_than_khan(X,Y) :-
		get_cell_value(X, Y, CellValue),
		get_khan_cell_value(KhanCellValue),
		CellValue =:= KhanCellValue,!.
/* Remarque : au début du jeu, le khan n'est pas placé, il faut donc renvoyer vrai si l'assertion ci-dessus ne passe pas.*/
cell_has_same_value_than_khan(X,Y) :-
		get_cell_value(X, Y, CellValue),
		\+get_khan_cell_value(KhanCellValue),!. % pour le premier coup de la partie, le khan n'est pas encore initialisé
















get_available_cells_khan_value_in_line([T|Q], [(I,J)|R]) :- 
		getI(I), getJ(J), % récupérer les valeurs courantes pour i et j
		cell_empty(I,J),
		cell_has_same_value_than_khan(I,J), % tester si la cellule i,j possède un pion
		incrementJ(1), % incrémenter j (colonne suivante) et l'enregistrer dans les faits dynamiques
		get_available_cells_khan_value_in_line(Q,R),!. % afficher le reste de la ligne
get_available_cells_khan_value_in_line([_|Q], R) :- 
		incrementJ(1), % incrémenter j (colonne suivante) et l'enregistrer dans les faits dynamiques
		get_available_cells_khan_value_in_line(Q,R),!. % afficher le reste de la ligne

get_available_cells_khan_value_in_line(_,[]) :- !.
get_available_cells_khan_value_in_line([],_) :- !.
get_available_cells_khan_value_in_line([],[]) :- !.

/* 
 * Prédicat qui va appeler le predicat get_available_cells_khan_value_in_line pour chaque ligne du plateau de jeu
 */
get_available_cells_khan_value_in_board([T|Q], [H|Rest]) :- 
		get_available_cells_khan_value_in_line(T,H),
		incrementI(1), setJ(1), % incrémenter i (ligne suivante) et remettre j à 0
		get_available_cells_khan_value_in_board(Q,Rest),!.
get_available_cells_khan_value_in_board(_,[]) :- !.
get_available_cells_khan_value_in_board([],_) :- !.
get_available_cells_khan_value_in_board([],[]) :- !.
/* 
 * Prédicat qui sert de lanceur au prédicat get_available_cells_khan_value_in_board :
 *  il faut en effet que i et j (surtout i) soit initialisés à 0
 */
get_all_cells_according_to_khan_cell_value(CellList) :-
		reset_index(), % reset les asserts faits sur i et j, puis donne à i et j la valeur 1
		activeBoard(Board),
		get_available_cells_khan_value_in_board(Board,CellList_Tmp),
		flatten(CellList_Tmp, CellList).























				% ===============================

/*
 * Permet de placer un pion : on supprime pour une case donnée les faits précédement enregistrés
 * et on rajouter dynamiquement le fait que le pion Pawn du joueur Player est sur la case X Y
 */
place_pawn(X, Y, Pawn, Player) :-
		retractall(pawn(X, Y, _, Player)), % supprimer l'historique de la case
		asserta(pawn(X,Y,Pawn,Player)). % ajouter la pièce
move_pawn(X, Y, NX, NY, Pawn, Player) :-
		retractall(pawn(X, Y, _, _)), % supprimer l'historique de la case
		retractall(pawn(NX, NY, _, _)), % supprimer l'historique de la case
		asserta(pawn(NX,NY,Pawn,Player)), % ajouter la pièce
		reset_khan(),
		asserta(khan(NX,NY)).

				% ===============================

/*
 * Prédicat qui permet de donner l'ensemble des coups possibles
 * à partir de la case de départ d'incide X et Y et du joueur qui joue
 */
possible_moves(X, Y, Player, 1, AlreadySeens, MoveList) :-
		finish_right(X,Y, NY, Player), % si on peut finir vers la droite
		\+member((X,NY),AlreadySeens),
		append([(X,NY)], [], MoveList).
		%write('finish_right.'), write(MoveList), nl.
possible_moves(X, Y, Player, 1, AlreadySeens, MoveList) :-
		finish_left(X,Y, NY, Player), % si on peut finir vers la droite
		\+member((X,NY),AlreadySeens),
		append([(X,NY)], [], MoveList).
		%write('finish_left.'), write(MoveList), nl.
possible_moves(X, Y, Player, 1, AlreadySeens, MoveList) :-
		finish_up(X,Y, NX, Player), % si on peut finir vers la droite
		\+member((NX,Y),AlreadySeens),
		append([(NX,Y)], [], MoveList).
		%write('finish_up.'), write(MoveList), nl.
possible_moves(X, Y, Player, 1, AlreadySeens, MoveList) :-
		finish_down(X,Y, NX, Player), % si on peut finir vers la droite
		\+member((NX,Y),AlreadySeens),
		append([(NX,Y)], [], MoveList).
		%write('finish_down.'), write(MoveList), nl.




possible_moves(X, Y, Player, Range, AlreadySeens, MoveList) :-
		Range > 1,
		NewRange is Range-1,
		move_right(X,Y, NY), % si on peut finir vers la droite
		\+member((X,NY),AlreadySeens),
		append([(X,NY)], AlreadySeens, AlreadySeens_Tmp),
		%write('move_right -> '),
		possible_moves(X, NY, Player, NewRange, AlreadySeens_Tmp, MoveList).

possible_moves(X, Y, Player, Range, AlreadySeens, MoveList) :-
		Range > 1,
		NewRange is Range-1,
		move_left(X,Y, NY), % si on peut finir vers la droite
		\+member((X,NY),AlreadySeens),
		append([(X,NY)], AlreadySeens, AlreadySeens_Tmp),
		%write('move_left -> '),
		possible_moves(X, NY, Player, NewRange, AlreadySeens_Tmp, MoveList).

possible_moves(X, Y, Player, Range, AlreadySeens, MoveList) :-
		Range > 1,
		NewRange is Range-1,
		move_up(X,Y, NX), % si on peut finir vers la droite
		\+member((NX,Y),AlreadySeens),
		append([(NX,Y)], AlreadySeens, AlreadySeens_Tmp),
		%write('move_up -> '),
		possible_moves(NX, Y, Player, NewRange, AlreadySeens_Tmp, MoveList).

possible_moves(X, Y, Player, Range, AlreadySeens, MoveList) :-
		Range > 1,
		NewRange is Range-1,
		move_down(X,Y, NX), % si on peut finir vers la droite
		\+member((NX,Y),AlreadySeens),
		append([(NX,Y)], AlreadySeens, AlreadySeens_Tmp),
		%write('move_down -> '),
		possible_moves(NX, Y, Player, NewRange, AlreadySeens_Tmp, MoveList).







% ========================================================================================
% ===============               PLACEMENT DES PIONS AU DEBUT              ================
% ========================================================================================




% ======= PREDICATS UTILES POUR LE PLACEMENT INITIAL DES PIONS  =======

/*
 * Prédicat de controle pour le placement des pions au début.
 * Le joueur 1 doit les placer en bas, le joueur 2 en haut, et la case doit etre vide.
 */
initial_pawn_placement_correct(Player, X, Y) :-
		no_pawn_player_in_cell(X,Y,Player),
		pawn_in_initial_lines(X,Y,Player).





% ======= PLACEMENT INITIAL DES PIONS  =======

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

			; 	writeInRed('Placement illegal, recommencez.'),
				ask_one_player_initial_pawns_placement(Player, [PawnsList_Head|Q])
		).
ask_one_player_initial_pawns_placement(Player, []).










% ========================================================================================
% ===========           DEPLACEMENT D'UNE PIECE AU COURS DU JEU             ==============
% ========================================================================================


/*
 * Prédicat donnant la liste des pièces etant de même type que celle où est placée le khan
 * get_possible_pawn(Player, UsedPawnList, PossiblePawnList)
 */
get_possible_pawn(_, [], []) :- !.
get_possible_pawn(Player, [T|Q], [T|R]) :-
		pawn(X,Y,T,Player), % réupérer les coordonées de la pièce en tête de liste
		cell_has_same_value_than_khan(X,Y), % vérifier que la case est de même type que celle du khan
		get_possible_pawn(Player,Q,R),!. % continuer le traitement en ayant ajouté la tete de liste à la liste des pions possibles

get_possible_pawn(Player, [T|Q], PossiblePawnList) :-
		get_possible_pawn(Player,Q,PossiblePawnList),!. % continuer le traitement en n'ayant pas ajouté la tete de liste à la liste des pions possibles



		

/*
 * Prédicat qui demande à un joueur de choisir la nouvelle position d'une pièce
 */
ask_pawn_new_position(I,J,MoveList,Pawn,Player) :-
		write('Voici les coups possible pour la pièce '),
		writeWithPlayerColor(Pawn,Player), writeWithPlayerColor(' : ',Player),
		writeWithPlayerColor(MoveList,Player), nl,
		write('Entrez les nouvelles coordonnées :'), nl,
		write('Ligne : '), read(X), % demander et lire l'indice de la ligne
		write('Colonne : '), read(Y), nl, % demander et lire l'indice de la colonne

		(check_good_coordonates(X,Y,MoveList) % vérifie que les coordonnées sont bien dans la liste des coups possibles, sinon on lui redemande de bonne coordonnées
			-> 	move_pawn(I, J, X, Y, Pawn, Player),
				dynamic_display_active_board()

			; 	writeInRed('Mauvaises coordonnées, recommencez SVP.'),nl,
				ask_pawn_new_position(I,J,MoveList,Pawn,Player)
		).

/*
 * Prédicat qui demande à un joueur de choisir la nouvelle position d'une pièce dans le cas où
 * il remet la pièce sur le plateau alors qu'elle était sortie du jeu
 */
ask_pawn_new_placement(MoveList,Pawn,Player) :-
		write('Voici les coups possible pour la pièce '),
		writeWithPlayerColor(Pawn,Player), writeWithPlayerColor(' : ',Player),
		writeWithPlayerColor(MoveList,Player), nl,
		write('Entrez les nouvelles coordonnées :'), nl,
		write('Ligne : '), read(X), % demander et lire l'indice de la ligne
		write('Colonne : '), read(Y), nl, % demander et lire l'indice de la colonne

		(check_good_coordonates(X,Y,MoveList) % vérifie que les coordonnées sont bien dans la liste des coups possibles, sinon on lui redemande de bonne coordonnées
			-> 	place_pawn(X, Y, Pawn, Player),
				dynamic_display_active_board()

			; 	writeInRed('Mauvaises coordonnées, recommencez SVP.'),nl,
				ask_pawn_new_placement(I,J,MoveList,Pawn,Player)
		).




/*
 * Prédicat qui demande à un joueur de choisir une pièce puis lui demande via le prédicat 
 * ask_movement_to_player où il veut la placer
 */
ask_movement_to_player(Player) :-
		pawnList(FullPawnList), % utile dans le cas où le joueur n'a aucune pièce présente sur une case du même type que celle du Khan
		get_unused_player_pawns(Player, UnusedPawnList), % utile dans le cas où le joueur possède des sbires qu'il peut remettre en jeu
		get_used_player_pawns(Player, UsedPawnList), % liste des pions du joueur qui sont sur le plateau
		get_possible_pawn(Player, UsedPawnList, PossiblePawnList_Tmp), % PossiblePawnList_Tmp contiendra la liste des pions du joueur qui sont sur une case du même type que la case actuelle du Khan
		length(PossiblePawnList_Tmp,NumberOfPossiblePawns), % récupérer la longueur de la liste PossiblePawnList_Tmp
		(NumberOfPossiblePawns =:= 0 % dans le cas où celle liste est vide, cela veut dire que le joueur n'a aucune pièce présente sur une case du même type que celle du Khan
			-> union([], FullPawnList, PossiblePawnList) % alors il peut jouer l'ensemble de ses pièces, qu'elles soient présentes où non sur le plateau
			; union([], PossiblePawnList_Tmp, PossiblePawnList) % sinon on unifie PossiblePawnList avec PossiblePawnList_Tmp et une liste vide
		),
		nl, writeWithPlayerColor('Joueur ', Player), writeWithPlayerColor(Player, Player), writeWithPlayerColor(' --> ', Player),
		write("Pièces possibles : "), writeWithPlayerColor(PossiblePawnList, Player), write(" (entrez le nom de celle que vous voulez jouer {'S1', ..., 'K'} ENTRE SIMPLES GUILLEMETS)"), nl,
		read(Pawn),
		

		(member_one_occurence(Pawn, PossiblePawnList) % dans le cas où la pièce entrée est dans la liste des pièces possibles

			-> 	(member_one_occurence(Pawn, UnusedPawnList) % dans le cas où il choisit un pion hors du jeu pour le remettre en jeu
				
				->	get_all_cells_according_to_khan_cell_value(MoveList), % la MoveList devient l'ensemble des cases du plateau libres et ayant la même valeur que la case sur laquelle est le khan
					ask_pawn_new_placement(MoveList,Pawn,Player) % prédicat spécial lorsqu'on remet la pièce sur le plateau pour ne pas supprimer les positions de toutes les autres pièces présentes sur le plateau


				;	pawn(I, J, Pawn, Player), % avoir les coordonnées I et J
					get_cell_value(I, J, CellValue), % récupérer la valeur de la case, puis l'ensemble des coups possibles et demander au joueur où il veut placer sa pièce
					setof(ML, possible_moves(I,J,Player,CellValue,[(I,J)],ML), ML),
					flatten(ML, MoveList),
					ask_pawn_new_position(I,J,MoveList,Pawn,Player)
				)
			; 	writeInRed('Vous ne pouvez pas jouer cette pièce, recommencez SVP.'),
				ask_movement_to_player(Player),!
		).




/* get_other_player(ActualPlayer, OtherPlayer) :- */
get_other_player(ActualPlayer, Player_2) :-
		player1(Player_1),player2(Player_2),
		ActualPlayer =:= Player_1,!.
get_other_player(ActualPlayer, Player_1) :- % si Player est le joueur 2, retourner le joueur 1
		player1(Player_1),player2(Player_2),
		ActualPlayer =:= Player_2,!.

human_vs_human_game_loop(Player) :-
		ask_movement_to_player(Player),
		get_other_player(Player, OtherPlayer),
		(player_win(Player)
			-> 	writeWithPlayerColor('Bravo joueur ', Player),
				writeWithPlayerColor(Player,Player),
				writeWithPlayerColor(', vous avez gagné !!!',Player),nl
			;	human_vs_human_game_loop(OtherPlayer)
		).
		


human_vs_human_launch_game() :-
		player1(Player_1),player2(Player_2), % avoir les valeurs numériques correspondantes au joueur 1 et 2
		human_vs_human_game_loop(Player_1).






player_win(Player) :-
		get_other_player(Player,OtherPlayer),
		get_unused_player_pawns(OtherPlayer, UnusedPawnList),
		member('K',UnusedPawnList),!.




