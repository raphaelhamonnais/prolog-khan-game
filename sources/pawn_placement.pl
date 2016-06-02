% ========================================================================================
% ========================================================================================
% ========================================================================================
% ===============              GERER LE DEPLACEMENT DES PIONS             ================
% ========================================================================================
% ========================================================================================
% ========================================================================================


/*
 * Prédicat qui permet de savoir si une cellule possède un pion ou pas
 */
is_cell_empty(X, Y) :- \+ pawn(X, Y, Pawn, Player).


place_pawn(X, Y, Pawn, Player) :-
		retractall(pawn(_, _, _, _)), % supprimer l'historique de la case
		asserta(pawn(X,Y,Pawn,Player)). % ajouter la pièce

		
