% ========================================================================================
% ========================================================================================
% ========================================================================================
% ===============        GESTION DE L'AFFICHAGE DU PLATEAU DE JEU       ==================
% ========================================================================================
% ========================================================================================
% ========================================================================================


writeWithPlayerColor(X, Player) :- 	Player =:= 1,
									ansi_format([fg(green)], '~w', [X]),!.
writeWithPlayerColor(X, Player) :- 	Player =:= 2,
									ansi_format([fg(cyan)], '~w', [X]),!.
writeInRed(X) :- ansi_format([fg(red)], '~w', [X]),!.
%writeWithPlayerColor(X, Player) :- 	ansi_format([bold,fg(white)], '~w', [X]),!.

%couleurs possibles : black, red, green, yellow, blue, magenta, cyan, white, default



% ========================================================================================
% ================      AFFICHAGE NON DYNAMIQUE (debut du jeu)          ==================
% ========================================================================================





% Predicats d'affichage qui permettent d'afficher le plateau permettant de choisir un côte
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
 * Predicat qui affiche une ligne du plateau de jeu :
 *   Pour chaque case du plateau, s'il existe un pion sur cette case,
 *   alors on affiche ce pion avec la couleur du joueur, sinon on affiche
 *   un underscore.
 */
dynamic_display_list([]).

/* Predicat special pour la Kalista afin que l'affichage soit aligne
	car les pions ont deux caractere quand la Kalista n'en possede qu'un */
dynamic_display_list([T|Q]) :- 
		getI(I), getJ(J), % recuperer les valeurs courantes pour i et j
		pawn(I, J, 'K', Player), % tester si la cellule i,j possede une Kalista
		write(T), write('-'),
		writeWithPlayerColor('K', Player), write('  '), % si c'est le cas, afficher avec les couleurs
		write(' |  '), % separer la case de la case suivante
		incrementJ(1), % incrementer j (colonne suivante) et l'enregistrer dans les faits dynamiques
		dynamic_display_list(Q), !. % afficher le reste de la ligne

dynamic_display_list([T|Q]) :- 
		getI(I), getJ(J), % recuperer les valeurs courantes pour i et j
		pawn(I, J, Pawn, Player), % tester si la cellule i,j possede un pion
		write(T), write('-'),
		writeWithPlayerColor(Pawn, Player), write(' '), % si c'est le cas, afficher avec les couleurs
		write(' |  '), % separer la case de la case suivante
		incrementJ(1), % incrementer j (colonne suivante) et l'enregistrer dans les faits dynamiques
		dynamic_display_list(Q), !. % afficher le reste de la ligne

dynamic_display_list([T|Q]) :- 
		getI(I), getJ(J), % recuperer les valeurs courantes pour i et j
		write(T), write('-'),
		write('_'), write('  '), % si pas de pion, afficher "_"
		write(' |  '), % separer la case de la case suivante
		incrementJ(1), % incrementer j (colonne suivante) et l'enregistrer dans les faits dynamiques
		dynamic_display_list(Q), !. % afficher le reste de la ligne

/*
dynamic_display_list([T|Q]) :- 
		getI(I), getJ(J), % recuperer les valeurs courantes pour i et j
		write(T), write('-'),
		(pawn(I, J, Pawn, Player) % tester si la cellule i,j possede un pion
			-> writeWithPlayerColor(Pawn, Player), write(' ') % si c'est le cas, afficher avec les couleurs
			; write('_'), write('  ') ), % sinon afficher "_"
		incrementJ(1), % incrementer j (colonne suivante) et l'enregistrer dans les faits dynamiques
		dynamic_display_list(Q), !. % afficher le reste de la ligne
*/

/* 
 * Predicat qui va appeler le predicat dynamic_display_list pour chaque ligne du plateau de jeu
 */
dynamic_display_table([]).
dynamic_display_table([T|Q]) :- 
		getI(I), % recuperer la valeur courante pour i
		write(I), write('  -- >    '), % afficher l'indice de ligne
		write('|  '), % premiere barre de separation en debut de ligne
		dynamic_display_list(T),
		nl,
		write('            -----------------------------------------------------'), % separer les lignes du plateau
		nl,
		incrementI(1), setJ(1), % incrementer i (ligne suivante) et remettre j a 0
		dynamic_display_table(Q).

/* 
 * Predicat qui sert de lanceur au predicat dynamic_display_table :
 *  il faut en effet que i et j (surtout i) soit initialises a 0
 */
dynamic_display_board(Board) :-
		reset_index(), % reset les asserts faits sur i et j, puis donne a i et j la valeur 1
		nl,nl,
		write('                1        2        3        4       5        6'), nl,
		write('                v        v        v        v       v        v'), nl, nl,
		write('            -----------------------------------------------------'), % premiere ligne de separation
		nl,
		dynamic_display_table(Board).

/* 
 * Predicat "pratique" qui permet d'afficher directement l'activeBoard
 *  il faut en effet que i et j (surtout i) soit initialises a 0
 */
dynamic_display_active_board() :-
		activeBoard(Board),
		dynamic_display_board(Board),
		write('Position du Khan : '),
		(khan(X,Y)
			-> 	get_khan_cell_value(Value),
				write(X), write(','), write(Y),
				write('  --->  vous ne pouvez jouer que des pieces etant sur des cases de valeur '), write(Value), nl,nl,nl

			; 	write('Pas encore de Khan.'), nl
		),
		!.



