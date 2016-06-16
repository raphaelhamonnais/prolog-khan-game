% ========================================================================================
% ========================================================================================
% ========================================================================================
% ===============                         ETAPE 1                       ==================
% ========================================================================================
% ========================================================================================
% ========================================================================================


/*
Definir un predicat permettant de generer le plateau initial du jeu. Le predicat gerera le positionnement
des pieces des differents joueurs. Il sera defini sous la forme:
initBoard( Board )
Un autre predicat devra afficher sur la console ce plateau de jeu, ainsi que l’interface du jeu
permettant de rentrer la position de ces pieces au debut du jeu ainsi que de selectionner un coup à jouer
(pour un joueur Humain).
*/







% ========================================================================================
% ======================           CHOOSE BOARD DISPLAY        ===========================
% ========================================================================================

%% ===============================================================================
%% ============================ ASK DISPLAY TO PLAYER ============================
%% ===============================================================================

askDisplayToPlayer(X) :- 	write('Please choose you side : a, b, c or d.'),
							nl,
							read(X).

initBoard() :- 	display_board_for_choose_side(),
				askDisplayToPlayer(VAL),
				chooseBoardDisplay(VAL, BOARD),
				retractall(activeBoard(_)),
				asserta(activeBoard(BOARD)),
				nl, write('Voici la disposition que vous avez choisie :'),nl, nl,
				dynamic_display_board(BOARD),
				!.



