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


% ============================================================
% ==== AVOIR L'ENSEMBLE DES PIONS NON UTILISES D'UN JOUEUR ===
% ============================================================
/*
 * construct_unused_pawns_list(Player, UnusedPawnList, FullPawnList)
 * Prédicat permettant d'unifier UnusedPawnList avec l'ensemble des pions du Player qui ne sont pas sur le plateau
 */
construct_unused_pawns_list(Player, UnusedPawnList, [PawnList_Head|PawnList_Left]) :-
		pawn(_, _, PawnList_Head, Player),
		construct_unused_pawns_list(Player, UnusedPawnList, PawnList_Left),
		!.
construct_unused_pawns_list(Player, [PawnList_Head|Q], [PawnList_Head|PawnList_Left]) :-
		\+pawn(_, _, PawnList_Head, Player),
		construct_unused_pawns_list(Player, Q, PawnList_Left),
		!.

construct_unused_pawns_list(Player, [], FullPawnList).

/*
 * get_unused_player_pawns(Player, UnusedPawnList)
 * Prédicat permettant d'unifier UnusedPawnList avec l'ensemble des pions du Player qui ne sont pas sur le plateau
 * 		-> construit FullPawnList et appelle construct_unused_pawns_list
 */
get_unused_player_pawns(Player, UnusedPawnList) :-
		pawnList(FullPawnList),
		construct_unused_pawns_list(Player, UnusedPawnList, FullPawnList).







% ========================================================================================
% ==============        PREDICATS DE RESET DES FAITS DYNAMIQUES       ====================
% ========================================================================================

reset_index():- retractall(i(_)), retractall(j(_)), asserta(i(0)), asserta(j(0)).
reset_pawn():- 	retractall(pawn(_, _, _, _)).

reset_all_dynamic_facts() :- reset_pawn(), reset_index().