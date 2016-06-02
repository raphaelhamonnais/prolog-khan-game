% ========================================================================================
% ========================================================================================
% ========================================================================================
% ====================        GESTION DES FAITS DYNAMIQUES       =========================
% ========================================================================================
% ========================================================================================
% ========================================================================================





% ========================================================================================
% ======================        BASE DE FAITS DYNAMIQUES       ===========================
% ========================================================================================

/*
 * Faits dynamique pour les indices de lignes et colonnes du plateau de jeu
 */
:-dynamic(i/1).
:-dynamic(j/1).


/* 
 * Fait dynamique qui nous servira à gérer les pions des joueurs sur le plateau
 *  Utilisation : pawn(i : Indice_ligne, j : Indice_colonne, Pion, Joueur)
 * 		- renvoie faux si pas de pion ij
 * 		- renvoie vrai s'il y a un pion à l'indice ij et unifie Pion et Joueur avec le 
 		  les valeurs du pion et du joueur
 */
:-dynamic(pawn/4).
	

/*
 * Fait dynamique permettant de sauvegarder le plateau de jeu actif
 */
:- dynamic (activeBoard/1).





% ========================================================================================
% ==============      PREDICATS D'UTILISATION DES FAITS DYNAMIQUES      ==================
% ========================================================================================


/*
construct_unused_pawns_list(Player, UnusedPawnList, [PawnList_Head|PawnList_Left]) :-
		pawn(_, _, PawnList_Head, Player),
		construct_unused_pawns_list(Player, UnusedPawnList, PawnList_Left),
		nl,write(1), write(UnusedPawnList),
		!.

construct_unused_pawns_list(Player, UnusedPawnList, [PawnList_Head|PawnList_Left]) :-
		\+pawn(_, _, PawnList_Head, Player),
		append([PawnList_Head], UnusedPawnList, UnusedPawnList_Temp), % sinon ajouter le pion dans la liste des pièces non utilisées
		nl,write(2), write(UnusedPawnList_Temp),
		construct_unused_pawns_list(Player, UnusedPawnList_Temp, PawnList_Left),
		copy(UnusedPawnList, UnusedPawnList_Temp), !.

construct_unused_pawns_list(Player, UnusedPawnList, []).

%% construct_unused_pawns_list(Player, UnusedPawnList, [PawnList_Head|PawnList_Left]) :-
%% 		write(PawnList_Head),
%% 		pawn(_, _, PawnList_Head, Player)
%% 				%-> append(Head, UnusedPawnList, UnusedPawnList), write('OK in if') % sinon ajouter le pion dans la liste des pièces non utilisées
%% 				-> write('true - '), write(PawnList_Head), write(Player) %si le pion est sur le plateau, ne rien faire, on n'ajoute pas la pièce dans la liste des pièces non utilisées
%% 				; append(PawnList_Head, UnusedPawnList, UnusedPawnList_Temp) % sinon ajouter le pion dans la liste des pièces non utilisées
%% 		,
%% 		construct_unused_pawns_list(Player, UnusedPawnList_Temp, PawnList_Left),!.

%construct_unused_pawns_list(Player, UnusedPawnList, []) :- !.

get_unused_player_pawns(Player, UnusedPawnList) :-
		pawnList(FullPawnList), write('OK1 - '), write(FullPawnList),
		construct_unused_pawns_list(Player, UnusedPawnList, FullPawnList).
%get_unused_player_pawns(Player, []).

*/


% ========================================================================================
% ==============        PREDICATS DE RESET DES FAITS DYNAMIQUES       ====================
% ========================================================================================

reset_index():- retractall(i(_)), retractall(j(_)), asserta(i(0)), asserta(j(0)).
reset_pawn():- 	retractall(pawn(_, _, _, _)).

reset_all_dynamic_facts() :- reset_pawn(), reset_index().