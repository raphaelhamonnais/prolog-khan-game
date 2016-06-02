% ========================================================================================
% ========================================================================================
% ========================================================================================
% ===============                         ETAPE 1                       ==================
% ========================================================================================
% ========================================================================================
% ========================================================================================


/*
Définir un prédicat permettant de générer le plateau initial du jeu. Le prédicat gèrera le positionnement
des pièces des différents joueurs. Il sera défini sous la forme:
initBoard( Board )
Un autre prédicat devra afficher sur la console ce plateau de jeu, ainsi que l’interface du jeu
permettant de rentrer la position de ces pièces au début du jeu ainsi que de sélectionner un coup à jouer
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
				asserta(pawn(1,1,'S1',1)),
				asserta(pawn(1,3,'S1',2)),
				dynamic_display_board(BOARD),
				!.



