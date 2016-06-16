/*
 * Predicat qui permet de savoir si une case de coordonnees X,Y est bien dans la liste de cases MoveList
 */
check_good_coordonates(X,Y,MoveList) :-
		member_one_occurence((X,Y),MoveList).


/*
 * Predicat qui renvoie vrai si un joueur peut passer (sans finir) sur une case (droite, gauche, haut, bas)
 *		move_***(X,Y)
 */
 move_right(X, Y, NY) :- NY is Y+1, cell_in_board(X,NY), cell_empty(X,NY).
 move_left(X, Y, NY) :- NY is Y-1, cell_in_board(X,NY), cell_empty(X,NY).
 move_up(X, Y, NX) :- NX is X-1, cell_in_board(NX,Y), cell_empty(NX,Y).
 move_down(X, Y, NX) :- NX is X+1, cell_in_board(NX,Y), cell_empty(NX,Y).

				% ===============================

 /*
 * Predicat qui renvoie vrai si un joueur peut finir sur une case (droite, gauche, haut, bas)
 * 		finish_***(X,Y,Player,Cell) ou Cell represente les coordonees de la case
 */
finish_right(X, Y, NY, Player) :- NY is Y+1, cell_in_board(X,NY), no_pawn_player_in_cell(X,NY, Player).
finish_left(X, Y, NY, Player) :- NY is Y-1, cell_in_board(X,NY), no_pawn_player_in_cell(X,NY, Player).
finish_up(X, Y, NX, Player) :- NX is X-1, cell_in_board(NX,Y), no_pawn_player_in_cell(NX,Y, Player).
finish_down(X, Y, NX, Player) :- NX is X+1, cell_in_board(NX,Y), no_pawn_player_in_cell(NX,Y, Player).

				% ===============================








get_available_cells_khan_value_in_line([T|Q], [(I,J)|R]) :- 
		getI(I), getJ(J), % recuperer les valeurs courantes pour i et j
		cell_empty(I,J),
		cell_has_same_value_than_khan(I,J), % tester si la cellule i,j possede un pion
		incrementJ(1), % incrementer j (colonne suivante) et l'enregistrer dans les faits dynamiques
		get_available_cells_khan_value_in_line(Q,R),!. % afficher le reste de la ligne
get_available_cells_khan_value_in_line([_|Q], R) :- 
		incrementJ(1), % incrementer j (colonne suivante) et l'enregistrer dans les faits dynamiques
		get_available_cells_khan_value_in_line(Q,R),!. % afficher le reste de la ligne

get_available_cells_khan_value_in_line(_,[]) :- !.
get_available_cells_khan_value_in_line([],_) :- !.
get_available_cells_khan_value_in_line([],[]) :- !.


/* 
 * Predicat qui va appeler le predicat get_available_cells_khan_value_in_line pour chaque ligne du plateau de jeu
 */
get_available_cells_khan_value_in_board([T|Q], [H|Rest]) :- 
		get_available_cells_khan_value_in_line(T,H),
		incrementI(1), setJ(1), % incrementer i (ligne suivante) et remettre j a 0
		get_available_cells_khan_value_in_board(Q,Rest),!.
get_available_cells_khan_value_in_board(_,[]) :- !.
get_available_cells_khan_value_in_board([],_) :- !.
get_available_cells_khan_value_in_board([],[]) :- !.
/* 
 * Predicat qui sert de lanceur au predicat get_available_cells_khan_value_in_board :
 *  il faut en effet que i et j (surtout i) soit initialises a 0
 */
get_all_cells_according_to_khan_cell_value(CellList) :-
		reset_index(), % reset les asserts faits sur i et j, puis donne a i et j la valeur 1
		activeBoard(Board),
		get_available_cells_khan_value_in_board(Board,CellList_Tmp),
		flatten(CellList_Tmp, CellList).









				% ===============================

/*
 * Predicat qui permet de donner l'ensemble des coups possibles
 * a partir de la case de depart d'incide X et Y et du joueur qui joue
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
% ===========           DEPLACEMENT D'UNE PIECE AU COURS DU JEU             ==============
% ========================================================================================


/*
 * Predicat donnant la liste des pieces etant de meme type que celle ou est placee le khan
 * get_possible_pawn(Player, UsedPawnList, PossiblePawnList)
 */
get_possible_pawn(_, [], []) :- !.
get_possible_pawn(Player, [T|Q], [T|R]) :-
		pawn(X,Y,T,Player), % reuperer les coordonees de la piece en tete de liste
		cell_has_same_value_than_khan(X,Y), % verifier que la case est de meme type que celle du khan
		get_possible_pawn(Player,Q,R),!. % continuer le traitement en ayant ajoute la tete de liste a la liste des pions possibles

get_possible_pawn(Player, [T|Q], PossiblePawnList) :-
		get_possible_pawn(Player,Q,PossiblePawnList),!. % continuer le traitement en n'ayant pas ajoute la tete de liste a la liste des pions possibles



		

/*
 * Predicat qui demande a un joueur de choisir la nouvelle position d'une piece
 */
ask_pawn_new_position(I,J,MoveList,Pawn,Player) :-
		write('Voici les coups possible pour la piece '),
		writeWithPlayerColor(Pawn,Player), writeWithPlayerColor(' : ',Player),
		writeWithPlayerColor(MoveList,Player), nl,
		write('Entrez les nouvelles coordonnees :'), nl,
		write('Ligne : '), read(X), % demander et lire l'indice de la ligne
		write('Colonne : '), read(Y), nl, % demander et lire l'indice de la colonne

		(check_good_coordonates(X,Y,MoveList) % verifie que les coordonnees sont bien dans la liste des coups possibles, sinon on lui redemande de bonne coordonnees
			-> 	move_pawn(I, J, X, Y, Pawn, Player),
				dynamic_display_active_board()

			; 	writeInRed('Mauvaises coordonnees, recommencez SVP.'),nl,
				ask_pawn_new_position(I,J,MoveList,Pawn,Player)
		).

/*
 * Predicat qui demande a un joueur de choisir la nouvelle position d'une piece dans le cas ou
 * il remet la piece sur le plateau alors qu'elle etait sortie du jeu
 */
ask_pawn_new_placement(MoveList,Pawn,Player) :-
		write('Voici les coups possible pour la piece '),
		writeWithPlayerColor(Pawn,Player), writeWithPlayerColor(' : ',Player),
		writeWithPlayerColor(MoveList,Player), nl,
		write('Entrez les nouvelles coordonnees :'), nl,
		write('Ligne : '), read(X), % demander et lire l'indice de la ligne
		write('Colonne : '), read(Y), nl, % demander et lire l'indice de la colonne

		(check_good_coordonates(X,Y,MoveList) % verifie que les coordonnees sont bien dans la liste des coups possibles, sinon on lui redemande de bonne coordonnees
			-> 	place_pawn(X, Y, Pawn, Player),
				dynamic_display_active_board()

			; 	writeInRed('Mauvaises coordonnees, recommencez SVP.'),nl,
				ask_pawn_new_placement(I,J,MoveList,Pawn,Player)
		).




/*
 * Predicat qui demande a un joueur de choisir une piece puis lui demande via le predicat 
 * ask_movement_to_player ou il veut la placer
 */
ask_movement_to_player(Player) :-
		pawnList(FullPawnList), % utile dans le cas ou le joueur n'a aucune piece presente sur une case du meme type que celle du Khan
		get_unused_player_pawns(Player, UnusedPawnList), % utile dans le cas ou le joueur possede des sbires qu'il peut remettre en jeu
		get_used_player_pawns(Player, UsedPawnList), % liste des pions du joueur qui sont sur le plateau
		get_possible_pawn(Player, UsedPawnList, PossiblePawnList_Tmp), % PossiblePawnList_Tmp contiendra la liste des pions du joueur qui sont sur une case du meme type que la case actuelle du Khan
		length(PossiblePawnList_Tmp,NumberOfPossiblePawns), % recuperer la longueur de la liste PossiblePawnList_Tmp
		(NumberOfPossiblePawns =:= 0 % dans le cas ou celle liste est vide, cela veut dire que le joueur n'a aucune piece presente sur une case du meme type que celle du Khan
			-> union([], FullPawnList, PossiblePawnList) % alors il peut jouer l'ensemble de ses pieces, qu'elles soient presentes ou non sur le plateau
			; union([], PossiblePawnList_Tmp, PossiblePawnList) % sinon on unifie PossiblePawnList avec PossiblePawnList_Tmp et une liste vide
		),
		nl, writeWithPlayerColor('Joueur ', Player), writeWithPlayerColor(Player, Player), writeWithPlayerColor(' --> ', Player),
		write("Pieces possibles : "), writeWithPlayerColor(PossiblePawnList, Player), write(" (entrez le nom de celle que vous voulez jouer {'S1', ..., 'K'} ENTRE SIMPLES GUILLEMETS)"), nl,
		read(Pawn),
		

		(member_one_occurence(Pawn, PossiblePawnList) % dans le cas ou la piece entree est dans la liste des pieces possibles

			-> 	(member_one_occurence(Pawn, UnusedPawnList) % dans le cas ou il choisit un pion hors du jeu pour le remettre en jeu
				
				->	get_all_cells_according_to_khan_cell_value(MoveList), % la MoveList devient l'ensemble des cases du plateau libres et ayant la meme valeur que la case sur laquelle est le khan
					ask_pawn_new_placement(MoveList,Pawn,Player) % predicat special lorsqu'on remet la piece sur le plateau pour ne pas supprimer les positions de toutes les autres pieces presentes sur le plateau


				;	pawn(I, J, Pawn, Player), % avoir les coordonnees I et J
					get_cell_value(I, J, CellValue), % recuperer la valeur de la case, puis l'ensemble des coups possibles et demander au joueur ou il veut placer sa piece
					setof(ML, possible_moves(I,J,Player,CellValue,[(I,J)],ML), ML),
					flatten(ML, MoveList),
					ask_pawn_new_position(I,J,MoveList,Pawn,Player)
				)
			; 	writeInRed('Vous ne pouvez pas jouer cette piece, recommencez SVP.'),
				ask_movement_to_player(Player),!
		).


