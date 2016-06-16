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
 * Fait dynamique qui nous servira a gerer les pions des joueurs sur le plateau
 *  Utilisation : pawn(i : Indice_ligne, j : Indice_colonne, Pion, Joueur)
 * 		- renvoie faux si pas de pion ij
 * 		- renvoie vrai s'il y a un pion a l'indice ij et unifie Pion et Joueur avec le 
 		  les valeurs du pion et du joueur
 */
:-dynamic(pawn/4).
:-dynamic(khan/2).

/*
 * Fait dynamique permettant de sauvegarder le plateau de jeu actif
 */
:-dynamic(activeBoard/1).



% ========================================================================================
% ==============        PREDICATS DE RESET DES FAITS DYNAMIQUES       ====================
% ========================================================================================

reset_activeBoard :- retractall(activeBoard(_)).
reset_index():- retractall(i(_)), retractall(j(_)), asserta(i(1)), asserta(j(1)).
reset_pawn():- 	retractall(pawn(_, _, _, _)).
reset_khan() :- retractall(khan(_, _)).
reset_all_dynamic_facts() :- reset_activeBoard(), reset_pawn(), reset_index(), reset_khan().









% ========================================================================================
% ==============      PREDICATS D'UTILISATION DES FAITS DYNAMIQUES      ==================
% ========================================================================================


% ============================================================
% ====     UTILISER LES INDICES DE PARCOURS DU PLATEAU     ===
% ============================================================
getI(I) :- i(I).
getJ(J) :- j(J).
setI(I) :- retractall(i(_)), asserta(i(I)).
setJ(J) :- retractall(j(_)), asserta(j(J)).
incrementI(Nb) :- i(I), NI is I+Nb, setI(NI).
incrementJ(Nb) :- j(J), NJ is J+Nb, setJ(NJ).




/*
 * Predicat qui permet de savoir si une cellule possede un pion ou pas
 */
cell_empty(X, Y) :- \+ pawn(X, Y, Pawn, Player).



/*
 * Predicat qui renvoie vrai si la cellule ne contient pas deja un pion appartenant au joueur Player
 */
no_pawn_player_in_cell(X,Y,Player) :-
		player1(Z), Player =:= Z, % dans le cas ou le Player = joueur 1 
		\+pawn(X,Y,_,Player),!.
no_pawn_player_in_cell(X,Y,Player) :-
		player2(Z), Player =:= Z, % dans le cas ou le Player = joueur 2
		\+pawn(X,Y,_,Player),!.




/*
 * Predicat qui renvoie la valeur de la case ou est place le khan
 */
get_khan_cell_value(CellValue) :-
		khan(X,Y),
		get_cell_value(X, Y, CellValue),!.


/*
 * Predicat qui renvoie vrai si la case X,Y a la meme valeur que celle du khan
 */
cell_has_same_value_than_khan(X,Y) :-
		get_cell_value(X, Y, CellValue),
		get_khan_cell_value(KhanCellValue),
		CellValue =:= KhanCellValue,!.
/* Remarque : au debut du jeu, le khan n'est pas place, il faut donc renvoyer vrai si l'assertion ci-dessus ne passe pas.*/
cell_has_same_value_than_khan(X,Y) :-
		get_cell_value(X, Y, CellValue),
		\+get_khan_cell_value(KhanCellValue),!. % pour le premier coup de la partie, le khan n'est pas encore initialise





% ============================================================
% ==== AVOIR L'ENSEMBLE DES PIONS NON UTILISES D'UN JOUEUR ===
% ============================================================
/*
 * construct_unused_pawns_list(Player, UnusedPawnList, FullPawnList)
 * Predicat permettant d'unifier UnusedPawnList avec l'ensemble des pions du Player qui ne sont pas sur le plateau
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



construct_used_pawns_list(Player, [PawnList_Head|Q], [PawnList_Head|PawnList_Left]) :-
		pawn(_, _, PawnList_Head, Player),
		construct_used_pawns_list(Player, Q, PawnList_Left),
		!.

construct_used_pawns_list(Player, UsedPawnList, [PawnList_Head|PawnList_Left]) :-
		\+pawn(_, _, PawnList_Head, Player),
		construct_used_pawns_list(Player, UsedPawnList, PawnList_Left),
		!.

construct_used_pawns_list(Player, [], FullPawnList).

/*
 * get_unused_player_pawns(Player, UnusedPawnList)
 * Predicat permettant d'unifier UnusedPawnList avec l'ensemble des pions du Player qui ne sont pas sur le plateau
 * 		-> construit FullPawnList et appelle construct_unused_pawns_list
 */
get_unused_player_pawns(Player, UnusedPawnList) :-
		pawnList(FullPawnList),
		construct_unused_pawns_list(Player, UnusedPawnList, FullPawnList).

get_used_player_pawns(Player, UsedPawnList) :-
		pawnList(FullPawnList),
		construct_used_pawns_list(Player, UsedPawnList, FullPawnList).

place_khan(X,Y) :-
		cell_in_board(X,Y),
		reset_khan(),
		asserta(khan(X, Y)).

/*
 * Permet de placer un pion : on supprime pour une case donnee les faits precedement enregistres
 * et on rajouter dynamiquement le fait que le pion Pawn du joueur Player est sur la case X Y
 */
place_pawn(X, Y, Pawn, Player) :-
		retractall(pawn(X, Y, _, Player)), % supprimer l'historique de la case
		asserta(pawn(X,Y,Pawn,Player)). % ajouter la piece

move_pawn(X, Y, NX, NY, Pawn, Player) :-
		retractall(pawn(X, Y, _, _)), % supprimer l'historique de la case
		retractall(pawn(NX, NY, _, _)), % supprimer l'historique de la case
		asserta(pawn(NX,NY,Pawn,Player)), % ajouter la piece
		place_khan(NX,NY).








