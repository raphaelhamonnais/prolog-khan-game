% ========================================================================================
% ========================================================================================
% ========================================================================================
% ===============        GESTION DE L'AFFICHAGE DU PLATEAU DE JEU       ==================
% ========================================================================================
% ========================================================================================
% ========================================================================================






% ========================================================================================
% ================      AFFICHAGE NON DYNAMIQUE (début du jeu)          ==================
% ========================================================================================

% Permet au joueur de choisir sa disposition suivant la lettre qu'il écrira sur la console
chooseBoardDisplay('a', [[3,1,2,2,3,1], [2,3,1,3,1,2], [2,1,3,1,3,2], [1,3,2,2,1,3], [3,1,3,1,3,1], [2,2,1,3,2,2]]).
chooseBoardDisplay('A', [[3,1,2,2,3,1], [2,3,1,3,1,2], [2,1,3,1,3,2], [1,3,2,2,1,3], [3,1,3,1,3,1], [2,2,1,3,2,2]]).
chooseBoardDisplay('b', [[2,3,1,2,2,3], [2,1,3,1,3,1], [1,3,2,3,1,2], [3,1,2,1,3,2], [2,3,1,3,1,3], [2,1,3,2,2,1]]).
chooseBoardDisplay('B', [[2,3,1,2,2,3], [2,1,3,1,3,1], [1,3,2,3,1,2], [3,1,2,1,3,2], [2,3,1,3,1,3], [2,1,3,2,2,1]]).
chooseBoardDisplay('c', [[2,2,3,1,2,2], [1,3,1,3,1,3], [3,1,2,2,3,1], [2,3,1,3,1,2], [2,1,3,1,3,2], [1,3,2,2,1,3]]).
chooseBoardDisplay('C', [[2,2,3,1,2,2], [1,3,1,3,1,3], [3,1,2,2,3,1], [2,3,1,3,1,2], [2,1,3,1,3,2], [1,3,2,2,1,3]]).
chooseBoardDisplay('d', [[1,2,2,3,1,2], [3,1,3,1,3,2], [2,3,1,2,1,3], [2,1,3,2,3,1], [1,3,1,3,1,2], [3,2,2,1,3,2]]).
chooseBoardDisplay('D', [[1,2,2,3,1,2], [3,1,3,1,3,2], [2,3,1,2,1,3], [2,1,3,2,3,1], [1,3,1,3,1,2], [3,2,2,1,3,2]]).



% Prédicats d'affichage qui permettent d'afficher le plateau permettant de choisir un côté
displayList([]).
displayList([T|Q]) :- write(' '), write(T), displayList(Q),!.

displayBoardClassic([]).
displayBoardClassic([T|Q]) :- displayList(T), nl, displayBoardClassic(Q).

display_board_for_choose_side([]).
display_board_for_choose_side :- board_for_choose_side(X), displayBoardClassic(X), !.








% ========================================================================================
% ======================          AFFICHAGE DYNAMIQUE          ===========================
% ========================================================================================

/* 
 * Prédicat qui affiche une ligne du plateau de jeu :
 *   Pour chaque case du plateau, s'il existe un pion sur cette case,
 *   alors on affiche ce pion avec la couleur du joueur, sinon on affiche
 *   un underscore.
 */
dynamic_display_list([]).

/* Prédicat spécial pour la Kalista afin que l'affichage soit aligné
	car les pions ont deux caractère quand la Kalista n'en possède qu'un */
dynamic_display_list([T|Q]) :- 
		getI(I), getJ(J), % récupérer les valeurs courantes pour i et j
		pawn(I, J, 'K', Player), % tester si la cellule i,j possède une Kalista
		write(T), write('-'),
		writeWithPlayerColor('K', Player), write('  '), % si c'est le cas, afficher avec les couleurs
		write(' |  '), % séparer la case de la case suivante
		incrementJ(1), % incrémenter j (colonne suivante) et l'enregistrer dans les faits dynamiques
		dynamic_display_list(Q), !. % afficher le reste de la ligne

dynamic_display_list([T|Q]) :- 
		getI(I), getJ(J), % récupérer les valeurs courantes pour i et j
		pawn(I, J, Pawn, Player), % tester si la cellule i,j possède un pion
		write(T), write('-'),
		writeWithPlayerColor(Pawn, Player), write(' '), % si c'est le cas, afficher avec les couleurs
		write(' |  '), % séparer la case de la case suivante
		incrementJ(1), % incrémenter j (colonne suivante) et l'enregistrer dans les faits dynamiques
		dynamic_display_list(Q), !. % afficher le reste de la ligne

dynamic_display_list([T|Q]) :- 
		getI(I), getJ(J), % récupérer les valeurs courantes pour i et j
		write(T), write('-'),
		write('_'), write('  '), % si pas de pion, afficher "_"
		write(' |  '), % séparer la case de la case suivante
		incrementJ(1), % incrémenter j (colonne suivante) et l'enregistrer dans les faits dynamiques
		dynamic_display_list(Q), !. % afficher le reste de la ligne

/*
dynamic_display_list([T|Q]) :- 
		getI(I), getJ(J), % récupérer les valeurs courantes pour i et j
		write(T), write('-'),
		(pawn(I, J, Pawn, Player) % tester si la cellule i,j possède un pion
			-> writeWithPlayerColor(Pawn, Player), write(' ') % si c'est le cas, afficher avec les couleurs
			; write('_'), write('  ') ), % sinon afficher "_"
		incrementJ(1), % incrémenter j (colonne suivante) et l'enregistrer dans les faits dynamiques
		dynamic_display_list(Q), !. % afficher le reste de la ligne
*/

/* 
 * Prédicat qui va appeler le predicat dynamic_display_list pour chaque ligne du plateau de jeu
 */
dynamic_display_table([]).
dynamic_display_table([T|Q]) :- 
		getI(I), % récupérer la valeur courante pour i
		write(I), write('  -- >    '), % afficher l'indice de ligne
		write('|  '), % première barre de séparation en début de ligne
		dynamic_display_list(T),
		nl,
		write('            -----------------------------------------------------'), % séparer les lignes du plateau
		nl,
		incrementI(1), setJ(1), % incrémenter i (ligne suivante) et remettre j à 0
		dynamic_display_table(Q).

/* 
 * Prédicat qui sert de lanceur au prédicat dynamic_display_table :
 *  il faut en effet que i et j (surtout i) soit initialisés à 0
 */
dynamic_display_board(Board) :-
		reset_index(), % reset les asserts faits sur i et j, puis donne à i et j la valeur 1
		nl,nl,
		write('                1        2        3        4       5        6'), nl,
		write('                v        v        v        v       v        v'), nl, nl,
		write('            -----------------------------------------------------'), % première ligne de séparation
		nl,
		dynamic_display_table(Board).

/* 
 * Prédicat "pratique" qui permet d'afficher directement l'activeBoard
 *  il faut en effet que i et j (surtout i) soit initialisés à 0
 */
dynamic_display_active_board() :-
		activeBoard(Board),
		dynamic_display_board(Board),
		write('Position du Khan : '),
		(khan(X,Y)
			-> 	get_khan_cell_value(Value),
				write(X), write(','), write(Y),
				write('  --->  vous ne pouvez jouer que des pièces étant sur des cases de valeur '), write(Value), nl,nl,nl

			; 	write('Pas encore de Khan.'), nl
		),
		!.



