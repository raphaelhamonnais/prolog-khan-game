
% ___________  Predicats pratiques de determination de strategie  _______________

:-dynamic(bestPawn/1).

% renvoie le joueur qui a gagne si la partie est finie
% renvoie faux si la partie n'est pas finie
game_ended(Player) :-
	player_win(1).
game_ended(Player) :-
	player_win(2).



% is_that_pawn_in_range(MoveList, Pawn, JoueurAdverse, X, Y)
% renvoie une valeur de X, Y si et seulement si le pion adverse specifie
% est atteignable dans la liste de mouvements
is_that_pawn_in_range([], Pawn, JoueurAdverse, X, Y) :-
	false.
is_that_pawn_in_range([T|Q], Pawn, JoueurAdverse, X, Y) :-
	pawn(X, Y, Pawn, JoueurAdverse),
	T = (X, Y), !.
is_that_pawn_in_range([T|Q], Pawn, JoueurAdverse, X, Y) :-
	is_that_pawn_in_range(Q, Pawn, JoueurAdverse, X, Y), !.

% ce predicat verifie si les pions de la liste PossiblePawnList
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


%recupere la liste de tous les mouvements possibles pour prendre un pion
%fonctionne pour un pion particulier ou pour n'importe quels pions
can_take_pawn(JoueurActif, JoueurAdverse, Pawn, MoveList) :-
	get_used_player_pawns(JoueurActif, UsedPawnList),
	get_possible_pawn(JoueurActif, UsedPawnList, PossiblePawnList),
	get_khan_cell_value(Range),
	setof(ML, can_take_pawn_r(JoueurActif, PossiblePawnList, Pawn, JoueurAdverse, Range, ML), ML),
	flatten(ML, MoveList).


% permet d'obtenir une liste de move dans le format de l'IA a partir
% des moves possibles d'une piece (donnees par possible_moves)
get_IAMoveFormat_from_PossibleMovesList(JoueurActif, JoueurAdverse, X, Y, MyPawn, [], []).
get_IAMoveFormat_from_PossibleMovesList(JoueurActif, JoueurAdverse, X, Y, MyPawn, [T|Q], [Move|ML]) :-
	get_IAMoveFormat_from_PossibleMovesList(JoueurActif, JoueurAdverse, X, Y, MyPawn, Q, ML),
	get_IAMoveFormat(JoueurActif, JoueurAdverse, X, Y, MyPawn, T, Move), !.



% Permet de convertir un Move donne par possible_moves dans le format de move de l'IA
get_IAMoveFormat(JoueurActif, JoueurAdverse, X, Y, MyPawn, (I,J), Move) :- 
	(pawn(X, Y, MyPawn, JoueurActif)
	->	(pawn(I, J, P, JoueurAdverse)
		->	Move = (X, Y, I, J, P, I, J, 0, 0)
		;	Move = (X, Y, I, J, 'V', 0, 0, 0, 0)
		)
	;	Move = (0, 0, 0, 0, MyPawn, 0, 0, I, J)
	), !.



% retourne tous les moves possibles d'un pion dans le format de move de l'IA
get_pawn_moves(JoueurActif, JoueurAdverse, Pawn, MoveList) :-
	get_khan_cell_value(Range),
	(pawn(X, Y, Pawn, JoueurActif)
	->	setof(MLflat, possible_moves(X, Y, JoueurActif, Range, [], MLflat), MLflat),
		flatten(MLflat, ML),
		get_IAMoveFormat_from_PossibleMovesList(JoueurActif, JoueurAdverse, X, Y, Pawn, ML, MoveList)
	;	get_all_cells_according_to_khan_cell_value(ML),
		get_IAMoveFormat_from_PossibleMovesList(JoueurActif, JoueurAdverse, 0, 0, Pawn, ML, MoveList)
	).


% retourne la liste des pions jouables d'un joueur
get_playable_player_pawns(Player, PossiblePawnList) :-
	pawnList(FullPawnList), % utile dans le cas ou le joueur n'a aucune piece presente sur une case du meme type que celle du Khan
	get_unused_player_pawns(Player, UnusedPawnList), % utile dans le cas ou le joueur possede des sbires qu'il peut remettre en jeu
	get_used_player_pawns(Player, UsedPawnList), % liste des pions du joueur qui sont sur le plateau
	get_possible_pawn(Player, UsedPawnList, PossiblePawnList_Tmp), % PossiblePawnList_Tmp contiendra la liste des pions du joueur qui sont sur une case du meme type que la case actuelle du Khan
	length(PossiblePawnList_Tmp,NumberOfPossiblePawns), % recuperer la longueur de la liste PossiblePawnList_Tmp
	(NumberOfPossiblePawns =:= 0 % dans le cas ou celle liste est vide, cela veut dire que le joueur n'a aucune piece presente sur une case du meme type que celle du Khan
		-> union([], FullPawnList, PossiblePawnList) % alors il peut jouer l'ensemble de ses pieces, qu'elles soient presentes ou non sur le plateau
		; union([], PossiblePawnList_Tmp, PossiblePawnList) % sinon on unifie PossiblePawnList avec PossiblePawnList_Tmp et une liste vide
	).


% predicats de check le type de mouvement
is_placement_move((0,0,0,0,_,0,0,_,_)).
is_simple_move((_,_,_,_,'V',0,0,0,0)).
is_kill_pawn_move((_,_,X,Y,_,X,Y,0,0)).


% applique le mouvement
apply_move(JoueurActif, JoueurAdverse, Pawn, (Xini, Yini, Xfin, Yfin, P, Iini, Jini, Ifin, Jfin)) :-
	Move = (Xini, Yini, Xfin, Yfin, P, Iini, Jini, Ifin, Jfin),
	(is_placement_move(Move)
	->	place_pawn(Ifin, Jfin, P, JoueurActif)
	;	move_pawn(Xini, Yini, Xfin, Yfin, Pawn, JoueurActif)
	).


% revert move_pawn
revert_move(JoueurDuMove, JoueurAdverse, Pawn, (Xini, Yini, Xfin, Yfin, P, Iini, Jini, Ifin, Jfin)) :-
	Move = (Xini, Yini, Xfin, Yfin, P, Iini, Jini, Ifin, Jfin),
	(is_placement_move(Move)
	->	retractall(pawn(Ifin, Jfin, _, _)),
		place_khan(Ifin, Jfin)
	;	move_pawn(Xfin, Yfin, Xini, Yini, Pawn, JoueurDuMove),
		(is_kill_pawn_move(Move)
		->	place_pawn(Iini, Jini, P, JoueurAdverse)
		;	is_simple_move(Move)
		),
		place_khan(Xini, Yini)
	).


% _________________  Obtenir les nombres menaçants  ____________________


%voir getThreatNumbers qui recupere le backtrack de cette fonction
getOneThreatNumber(JoueurActif, JoueurAdverse, CellValue) :-
	pawn(X, Y, T, JoueurAdverse),
	get_cell_value(X, Y, CellValue),
	get_used_player_pawns(JoueurAdverse, UsedPawnList),
	get_possible_pawn(JoueurAdverse, UsedPawnList, PossiblePawnList),
	setof(ML, possible_moves(X, Y, JoueurAdverse, CellValue, [], ML), ML),
	flatten(ML, MoveList),
	is_that_pawn_in_range(MoveList, 'K', JoueurActif, I, J).


% Permet de determiner quelles pieces adverses peuvent prendre la kalista
% au prochain tour. Retourne la liste des chiffres du plateau ou se trouvent ces pions
getThreatNumbers(JoueurActif, JoueurAdverse, ThreatNumbers) :-
	findall(CV, getOneThreatNumber(JoueurActif, JoueurAdverse, CV), CV),
	flatten(CV, ThreatNumbers).



% ___________  Strategie 1 : Prendre la Kalista Adverse  _______________

% La premiere strategie appellee est celle la :
% Gagner la partie est de toute evidence le meilleur coup a jouer
tryToTakeKalista(JoueurActif, JoueurAdverse, Move) :-
	can_take_pawn(JoueurActif, JoueurAdverse, 'K', MoveList).



% ___________________  Strategie min max  _______________________

eval(JoueurActif, JoueurAdverse, Weight) :-
	getThreatNumbers(JoueurActif, JoueurAdverse, TN),
	getThreatNumbers(JoueurAdverse, JoueurActif, TNA),
	set(TN, TNnodup),
	set(TNA, TNAnodup),
	length(TN, LTN),
	length(TNA, LTNA),
	length(TNnodup, LTNnodup),
	length(TNAnodup, LTNAnodup),
	Weight is LTNAnodup * LTNAnodup + LTNA - LTNnodup * LTNnodup - LTN.


% fonction MIN

min_move_iter(_, _, _, _, [], MinVal, BestMove, NewMinVal, NewBestMove) :-
	NewMinVal = MinVal,
	NewBestMove = BestMove.	
min_move_iter(Depth, JoueurActif, JoueurAdverse, Pawn, [T|Q], MinVal, BestMove, NewMinVal, NewBestMove) :-
	apply_move(JoueurActif, JoueurAdverse, Pawn, T),
	D is Depth - 1,
	max(JoueurAdverse, JoueurActif, D, Val),
	(Val < MinVal
	->	MinVal2 = Val, BestMove2 = T, retractall(bestPawn(_)), asserta(bestPawn(Pawn))
	;	MinVal2 = MinVal, BestMove2 = BestMove
	),
	revert_move(JoueurActif, JoueurAdverse, Pawn, T),
	min_move_iter(Depth, JoueurActif, JoueurAdverse, Pawn, Q, MinVal2, BestMove2, NewMinVal2, NewBestMove2),
	NewMinVal = NewMinVal2,
	NewBestMove = NewBestMove2.

min_pawn_iter(_, _, _, [], MinVal, BestMove, NewMinVal, NewBestMove) :-
	NewMinVal = MinVal,
	NewBestMove = BestMove.
min_pawn_iter(Depth, JoueurActif, JoueurAdverse, [T|Q], MinVal, BestMove, NewMinVal, NewBestMove) :-
	get_pawn_moves(JoueurActif, JoueurAdverse, T, MoveList),
	min_move_iter(Depth, JoueurActif, JoueurAdverse, T, MoveList, MinVal, BestMove, NewMinVal2, NewBestMove2),
	min_pawn_iter(Depth, JoueurActif, JoueurAdverse, Q, NewMinVal2, NewBestMove2, NewMinVal3, NewBestMove3),
	NewMinVal = NewMinVal3,
	NewBestMove = NewBestMove3.

min(JoueurActif, JoueurAdverse, Depth, Val) :-
	(Depth = 0
	->	eval(JoueurActif, JoueurAdverse, Val)
	;	(game_ended(P)
		->	eval(JoueurActif, JoueurAdverse, Val)
		;	MinVal = 999,
			get_playable_player_pawns(JoueurActif, PawnsList),
			min_pawn_iter(Depth, JoueurActif, JoueurAdverse, PawnsList, MinVal, [], NewMinVal, NewBestMove),
			Val = MinVal
		)
	).


% fonction MAX

max_move_iter(_, _, _, _, [], MaxVal, BestMove, NewMaxVal, NewBestMove) :-
	NewMaxVal = MaxVal,
	NewBestMove = BestMove.	
max_move_iter(Depth, JoueurActif, JoueurAdverse, Pawn, [T|Q], MaxVal, BestMove, NewMaxVal, NewBestMove) :-
	apply_move(JoueurActif, JoueurAdverse, Pawn, T),
	D is Depth - 1,
	min(JoueurAdverse, JoueurActif, D, Val),
	(Val > MaxVal
	->	MaxVal2 = Val, BestMove2 = T, retractall(bestPawn(_)), asserta(bestPawn(Pawn))
	;	MaxVal2 = MaxVal, BestMove2 = BestMove
	),
	revert_move(JoueurActif, JoueurAdverse, Pawn, T),
	max_move_iter(Depth, JoueurActif, JoueurAdverse, Pawn, Q, MaxVal2, BestMove2, NewMaxVal2, NewBestMove2),
	NewMaxVal = NewMaxVal2,
	NewBestMove = NewBestMove2.

max_pawn_iter(_, _, _, [], MaxVal, BestMove, NewMaxVal, NewBestMove) :-
	NewMaxVal = MaxVal,
	NewBestMove = BestMove.
max_pawn_iter(Depth, JoueurActif, JoueurAdverse, [T|Q], MaxVal, BestMove, NewMaxVal, NewBestMove) :-
	get_pawn_moves(JoueurActif, JoueurAdverse, T, MoveList),
	max_move_iter(Depth, JoueurActif, JoueurAdverse, T, MoveList, MaxVal, BestMove, NewMaxVal2, NewBestMove2),
	max_pawn_iter(Depth, JoueurActif, JoueurAdverse, Q, NewMaxVal2, NewBestMove2, NewMaxVal3, NewBestMove3),
	NewMaxVal = NewMaxVal3,
	NewBestMove = NewBestMove3.

max(JoueurActif, JoueurAdverse, Depth, Val) :-
	(Depth = 0
	->	eval(JoueurActif, JoueurAdverse, Val)
	;	(game_ended(P)
		->	eval(JoueurActif, JoueurAdverse, Val)
		;	MaxVal = -999,
			get_playable_player_pawns(JoueurActif, PawnsList),
			max_pawn_iter(Depth, JoueurActif, JoueurAdverse, PawnsList, MaxVal, [], NewMaxVal, NewBestMove),
			Val = NewMaxVal
		)
	).

% Fonction JOUE

joue(JoueurActif, JoueurAdverse, Depth) :-
	MaxVal = -999,
	get_playable_player_pawns(JoueurActif, PawnsList),
	max_pawn_iter(Depth, JoueurActif, JoueurAdverse, PawnsList, MaxVal, [], NewMaxVal, NewBestMove),
	MaxVal2 = NewMaxVal,
	BestMove = NewBestMove,
	bestPawn(Pawn),
	apply_move(JoueurActif, JoueurAdvers, Pawn, BestMove),
	retractall(bestPawn(_)), !.

