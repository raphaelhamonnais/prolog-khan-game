% Joueur1 a pour numero 1
player1(1).
% Joueur2 a pour numero 2
player2(2).
% Liste des pions possibles pour un joueur : 5 sbires (S) et une Kalista (K)
pawnList(['S1', 'S2', 'S3', 'S4', 'S5', 'K']).






%% 	Plateau de jeu :
%%		         c
%%	  [ 3,  1,  2,  2,  3, 1]
%%    [ 2,  3,  1,  3,  1, 2]
%% d  [ 2,  1,  3,  1,  3, 2]  b
%%    [ 1,  3,  2,  2,  1, 3]
%%    [ 3,  1,  3,  1,  3, 1]
%%    [ 2,  2,  1,  3,  2, 2]
%%		         a


% Permettra d'afficher un plateau de jeu avec les quatres dispositions possibles bien visibles
board_for_choose_side(
			[
				[' ', ' ', ' ',' ','c',' ',' ',' ',' ', ' '],
				[' ', ' ',  3,  1,  2,  2,  3,  1, ' ', ' '],
				[' ', ' ',  2,  3,  1,  3,  1,  2, ' ', ' '],
				['d', ' ',  2,  1,  3,  1,  3,  2, ' ', 'b'],
				[' ', ' ',  1,  3,  2,  2,  1,  3, ' ', ' '],
				[' ', ' ',  3,  1,  3,  1,  3,  1, ' ', ' '],
				[' ', ' ',  2,  2,  1,  3,  2,  2, ' ', ' '],
				[' ', ' ', ' ',' ','a',' ',' ',' ',' ', ' ']
			]).

% Permet au joueur de choisir sa disposition suivant la lettre qu'il ecrira sur la console
chooseBoardDisplay('a', [[3,1,2,2,3,1], [2,3,1,3,1,2], [2,1,3,1,3,2], [1,3,2,2,1,3], [3,1,3,1,3,1], [2,2,1,3,2,2]]).
chooseBoardDisplay('A', [[3,1,2,2,3,1], [2,3,1,3,1,2], [2,1,3,1,3,2], [1,3,2,2,1,3], [3,1,3,1,3,1], [2,2,1,3,2,2]]).
chooseBoardDisplay('b', [[2,3,1,2,2,3], [2,1,3,1,3,1], [1,3,2,3,1,2], [3,1,2,1,3,2], [2,3,1,3,1,3], [2,1,3,2,2,1]]).
chooseBoardDisplay('B', [[2,3,1,2,2,3], [2,1,3,1,3,1], [1,3,2,3,1,2], [3,1,2,1,3,2], [2,3,1,3,1,3], [2,1,3,2,2,1]]).
chooseBoardDisplay('c', [[2,2,3,1,2,2], [1,3,1,3,1,3], [3,1,2,2,3,1], [2,3,1,3,1,2], [2,1,3,1,3,2], [1,3,2,2,1,3]]).
chooseBoardDisplay('C', [[2,2,3,1,2,2], [1,3,1,3,1,3], [3,1,2,2,3,1], [2,3,1,3,1,2], [2,1,3,1,3,2], [1,3,2,2,1,3]]).
chooseBoardDisplay('d', [[1,2,2,3,1,2], [3,1,3,1,3,2], [2,3,1,2,1,3], [2,1,3,2,3,1], [1,3,1,3,1,2], [3,2,2,1,3,2]]).
chooseBoardDisplay('D', [[1,2,2,3,1,2], [3,1,3,1,3,2], [2,3,1,2,1,3], [2,1,3,2,3,1], [1,3,1,3,1,2], [3,2,2,1,3,2]]).




/*
 * Predicat qui renvoie la valeur d'une case d'indice X et Y
 */
get_cell_value(X, Y, CellValue) :-
		activeBoard(Board),
		element_position_n(X, Board, Wanted_Line),
		element_position_n(Y, Wanted_Line, CellValue),!.

/*
 * Predicat qui verifie que les coordonnees X et Y sont dans le plateau
 */
cell_in_board(X,Y) :- X >= 1, X =<6, Y >= 1, Y =<6.

/* get_other_player(ActualPlayer, OtherPlayer) :- */
get_other_player(ActualPlayer, Player_2) :-
		player1(Player_1),player2(Player_2),
		ActualPlayer =:= Player_1,!.
get_other_player(ActualPlayer, Player_1) :- % si Player est le joueur 2, retourner le joueur 1
		player1(Player_1),player2(Player_2),
		ActualPlayer =:= Player_2,!.