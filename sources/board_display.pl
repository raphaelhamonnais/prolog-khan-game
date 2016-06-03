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
		dynamic_display_board(Board), !.










% ========================================================================================
% ======================    ANCIENNES VERSIONS DE PREDICATS    ===========================
% ========================================================================================


/*:-dynamic(s1j1/4).
:-dynamic(s2j1/4).
:-dynamic(s3j1/4).
:-dynamic(s4j1/4).
:-dynamic(s5j1/4).
:-dynamic(kj1/4).
:-dynamic(s1j2/4).
:-dynamic(s2j2/4).
:-dynamic(s3j2/4).
:-dynamic(s4j2/4).
:-dynamic(s5j2/4).
:-dynamic(kj2/4).*/


/*
init_dynamic_fact() :- 	reset_pawn(),
						asserta(s1j1('S', 1, 0,0)),
						asserta(s2j1('S', 1, 0,1)),
						asserta(s3j1('S', 1, 0,2)),
						asserta(s4j1('S', 1, 0,3)),
						asserta(s5j1('S', 1, 0,4)),
						asserta(kj1('K', 1, 0,5)),
						asserta(s1j2('S', 2, 5,0)),
						asserta(s2j2('S', 2, 5,1)),
						asserta(s3j2('S', 2, 5,2)),
						asserta(s4j2('S', 2, 5,3)),
						asserta(s5j2('S', 2, 5,4)),
						asserta(kj2('K', 2, 5,5)),
						reset_index().
*/



/*
dynamic_display([]).
dynamic_display([[T|Q1]|Q2]):- dynamic_display([T|Q1]),
						asserta(j(0)),
						nl,
						i(I),
						NI is I+1,
						asserta(i(NI)),
						dynamic_display(Q2),
						!.
						
dynamic_display([T|Q]):- i(I),
						j(J),
						pawn(I, J, Pawn, Player),
						!,
						write(T),
						write('-'),
						writeWithPlayerColor(Pawn, Player),
						write(' '),
						NJ is J+1,
						asserta(j(NJ)),
						dynamic_display(Q),
						!.

dynamic_display([T|Q]):- i(I),
						j(J),
						write(T),
						write('-'),
						write('_'),
						write(' '),
						NJ is J+1,
						asserta(j(NJ)),
						dynamic_display(Q),
						!.
*/


/*pawn(X, Y, Pawn, Player) :-	s1j1(Pawn, Player, X, Y), !.
pawn(X, Y, Pawn, Player) :-	s2j1(Pawn, Player, X, Y), !.
pawn(X, Y, Pawn, Player) :-	s3j1(Pawn, Player, X, Y), !.
pawn(X, Y, Pawn, Player) :-	s4j1(Pawn, Player, X, Y), !.
pawn(X, Y, Pawn, Player) :-	s5j1(Pawn, Player, X, Y), !.
pawn(X, Y, Pawn, Player) :-	kj1(Pawn, Player, X, Y), !.
pawn(X, Y, Pawn, Player) :-	s1j2(Pawn, Player, X, Y), !.
pawn(X, Y, Pawn, Player) :-	s2j2(Pawn, Player, X, Y), !.
pawn(X, Y, Pawn, Player) :-	s3j2(Pawn, Player, X, Y), !.
pawn(X, Y, Pawn, Player) :-	s4j2(Pawn, Player, X, Y), !.
pawn(X, Y, Pawn, Player) :-	s5j2(Pawn, Player, X, Y), !.
pawn(X, Y, Pawn, Player) :-	kj2(Pawn, Player, X, Y), !.
pawn(_, _, '_', 0).*/











/*
dynamic_display_list([T|Q]) :- 
		i(I), j(J), % récupérer les valeurs courantes pour i et j
		write(T), write('-'),
		(pawn(I, J, Pawn, Player) % tester si la cellule i,j possède un pion
			-> writeWithPlayerColor(Pawn, Player), write(' ') % si c'est le cas, afficher avec les couleurs
			; write('_'), write('  ') ), % sinon afficher "_"
		NJ is J+1, retractall(j(_)), asserta(j(NJ)), % incrémenter j (colonne suivante) et l'enregistrer dans les faits dynamiques
		dynamic_display_list(Q), !. % afficher le reste de la ligne

*/
/*
dynamic_display_list([T|Q]) :- 
		i(I), j(J), % récupérer les valeurs courantes pour i et j
		write('('), write(I), write(J), write(')'),
		pawn(I, J, Pawn, Player), % tester si la cellule i,j possède un pion
		write(T), write('-'),
		writeWithPlayerColor(Pawn, Player), write(' '), % si c'est le cas, afficher avec les couleurs
		NJ is J+1, retractall(j(_)), asserta(j(NJ)), % incrémenter j (colonne suivante) et l'enregistrer dans les faits dynamiques
		dynamic_display_list(Q). % afficher le reste de la ligne


dynamic_display_list([T|Q]) :- 
		i(I), j(J), % récupérer les valeurs courantes pour i et j
		\+pawn(I, J, Pawn, Player), % tester si la cellule i,j est vide
		write(T), write('-'),
		write('_'), write(' '), % si c'est le cas, afficher "_"
		NJ is J+1, retractall(j(_)), asserta(j(NJ)), % incrémenter j (colonne suivante) et l'enregistrer dans les faits dynamiques
		dynamic_display_list(Q). % afficher le reste de la ligne
*/


