% Joueur1 a pour numéro 1
player1(1).
% Joueur2 a pour numéro 2
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
