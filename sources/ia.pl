
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
can_take_pawn_r(JoueurActif, [], Pawn, JoueurAdverse, Range, []).
can_take_pawn_r(JoueurActif, [T|Q], Pawn, JoueurAdverse, Range, Move) :-
	pawn(X, Y, T, JoueurActif),
	setof(ML, possible_moves(X, Y, JoueurActif, Range, [], ML), ML),
	flatten(ML, MoveList),
	is_that_pawn_in_range(MoveList, Pawn, JoueurAdverse, I, J),
	Move = [(X, Y, I, J, Pawn, I, J, 0, 0)].
can_take_pawn_r(JoueurActif, [T|Q], Pawn, JoueurAdverse, Range, Move) :-
	can_take_pawn_r(JoueurActif, Q, Pawn, JoueurAdverse, Range, Move).


%récupère la liste de tous les mouvements possibles pour prendre un pion
%fonctionne pour un pion particulier ou pour n'importe quels pions
can_take_pawn(JoueurActif, JoueurAdverse, Pawn, MoveList) :-
	get_used_player_pawns(JoueurActif, UsedPawnList),
	get_possible_pawn(JoueurActif, UsedPawnList, PossiblePawnList),
	get_khan_cell_value(Range),
	setof(ML, can_take_pawn_r(JoueurActif, PossiblePawnList, Pawn, JoueurAdverse, Range, ML), ML),
	flatten(ML, MoveList).


% retourne tous les moves possibles d'un pion dans le format de move de l'IA
get_pawn_moves(JoueurActif, JoueurAdverse, Pawn, MoveList) :-
	pawn(X, Y, Pawn, JoueurActif),
	get_khan_cell_value(Range),
	setof(MLflat, possible_moves(X, Y, JoueurActif, Range, [], MLflat), MLflat),
	flatten(MLflat, ML).


truc(JoueurActif, JoueurAdverse, X, Y, [], []).
truc(JoueurActif, JoueurAdverse, X, Y, [(I,J)|Q], MoveList) :- 
	pawn(I, J, P, JoueurAdverse),
	-> MoveList = [(X, Y, I, J, P, I, J, 0, 0)],
	; MoveList = [(X, Y, I, J, 'V', 0, 0, 0, 0)].

	
	






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
	can_take_pawn(JoueurActif, JoueurAdverse, 'K', MoveList).

