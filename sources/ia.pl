
% ___________  Prédicats pratiques de détermination de stratégie  _______________

% is_that_pawn_in_range(MoveList, Pawn, JoueurAdverse, X, Y)
% renvoie une valeur de X, Y si et seulement si le pion adverse spécifié
% est atteignable dans la liste de mouvements
is_that_pawn_in_range([], Pawn, JoueurAdverse, X, Y) :-
	fail.
is_that_pawn_in_range([T|Q], Pawn, JoueurAdverse, X, Y) :-
	pawn(X, Y, Pawn, JoueurAdverse),
	T = (X, Y), !.
is_that_pawn_in_range([T|Q], Pawn, JoueurAdverse, X, Y) :-
	is_that_pawn_in_range(Q, Pawn, JoueurAdverse, X, Y), !.

% ce prédicat vérifie si les pions de la liste PossiblePawnList
% peuvent prendre le pion adverse renseigne en parametre
% can_take_pawn(JoueurActif, PossiblePawnList, Pawn, JoueurAdverse, Move)
can_take_pawn(JoueurActif, [], Pawn, JoueurAdverse, []).
can_take_pawn(JoueurActif, [T|Q], Pawn, JoueurAdverse, Move) :-
	pawn(X, Y, T, JoueurActif),
	get_khan_cell_value(Range),
	setof(ML, possible_moves(X, Y, JoueurActif, Range, [], ML), ML),
	flatten(ML, MoveList),
	is_that_pawn_in_range(MoveList, Pawn, JoueurAdverse, I, J),
	Move = [(I, J)], !.
can_take_pawn(JoueurActif, [T|Q], Pawn, JoueurAdverse, Move) :-
	can_take_pawn(JoueurActif, Q, Pawn, JoueurAdverse, Move), !.


% _________________  Obtenir les nombres menaçants  ____________________

%voir getThreatNumbers qui récupère le backtrack de cette fonction
getOneThreatNumber(JoueurActif, JoueurAdverse, CellValue) :-
	pawn(X, Y, T, JoueurAdverse),
	get_cell_value(X, Y, CellValue),
	get_used_player_pawns(JoueurAdverse, UsedPawnList),
	get_possible_pawn(JoueurAdverse, UsedPawnList, PossiblePawnList),
	setof(ML, possible_moves(X, Y, JoueurAdverse, CellValue, [], ML), ML),
	flatten(ML, MoveList),
	is_that_pawn_in_range(MoveList, 'K', JoueurActif, I, J).


% Permet de déterminer quelles pièces adverses peuvent prendre la kalista
% au prochain tour. Retourne la liste des chiffres du plateau où se trouvent ces pions
getThreatNumbers(JoueurActif, JoueurAdverse, ThreatNumbers) :-
	setof(CV, getOneThreatNumber(JoueurActif, JoueurAdverse, CV), CV),
	flatten(CV, ThreatNumbers).


% ___________  Stratégie 1 : Prendre la Kalista Adverse  _______________

% La première stratégie appellée est celle là :
% Gagner la partie est de toute évidence le meilleur coup à jouer
tryToTakeKalista(JoueurActif, JoueurAdverse, Move) :-
	get_used_player_pawns(JoueurActif, UsedPawnList),
	get_possible_pawn(JoueurActif, UsedPawnList, PossiblePawnList),
	can_take_pawn(JoueurActif, PossiblePawnList, 'K', JoueurAdverse, Move).

