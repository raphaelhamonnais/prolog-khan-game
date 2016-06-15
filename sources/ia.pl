
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


% permet d'obtenir une liste de move dans le format de l'IA à partir
% des moves possibles d'une pièce (données par possible_moves)
get_IAMoveFormat_from_PossibleMovesList(JoueurActif, JoueurAdverse, X, Y, MyPawn, [], []).
get_IAMoveFormat_from_PossibleMovesList(JoueurActif, JoueurAdverse, X, Y, MyPawn, [T|Q], [Move|ML]) :-
	get_IAMoveFormat_from_PossibleMovesList(JoueurActif, JoueurAdverse, X, Y, MyPawn, Q, ML),
	get_IAMoveFormat(JoueurActif, JoueurAdverse, X, Y, MyPawn, T, Move), !.



% Permet de convertir un Move donné par possible_moves dans le format de move de l'IA
get_IAMoveFormat(JoueurActif, JoueurAdverse, X, Y, MyPawn, (I,J), Move) :- 
	(pawn(X, Y, MyPawn, JoueurActif)
	->	(pawn(I, J, P, JoueurAdverse)
		->	Move = [(X, Y, I, J, P, I, J, 0, 0)]
		;	Move = [(X, Y, I, J, 'V', 0, 0, 0, 0)]
		)
	;	Move = [(0, 0, 0, 0, MyPawn, 0, 0, I, J)]
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









is_placement_move((0,0,0,0,_,0,0,_,_)).
is_simple_move((_,_,_,_,'V',0,0,0,0)).
is_kill_pawn_move((_,_,X,Y,_,X,Y,0,0)).



% applique le mouvement
apply_move(JoueurActif, JoueurAdverse, Pawn, (Xini, Yini, Xfin, Yfin, P, Iini, Jini, Ifin, Jfin)) :-
	Move = (Xini, Yini, Xfin, Yfin, P, Iini, Jini, Ifin, Jfin),
	(is_placement_move(Move)
	->	place_pawn(Ifin, Jfin, P, JoueurActif)
	;	move_pawn(Xini, Yini, Xfin, Yfin, P, JoueurActif)
	).






















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








%%%%%%%% COPIAGE DE CODE POUR L'INSPIRATION %%%%%%%%


/*


 * Permet de placer un pion : on supprime pour une case donnée les faits précédement enregistrés
 * et on rajouter dynamiquement le fait que le pion Pawn du joueur Player est sur la case X Y

place_pawn(X, Y, Pawn, Player) :-
		retractall(pawn(X, Y, _, Player)), % supprimer l'historique de la case
		asserta(pawn(X,Y,Pawn,Player)). % ajouter la pièce

move_pawn(X, Y, NX, NY, Pawn, Player) :-
		retractall(pawn(X, Y, _, _)), % supprimer l'historique de la case
		retractall(pawn(NX, NY, _, _)), % supprimer l'historique de la case
		asserta(pawn(NX,NY,Pawn,Player)), % ajouter la pièce
		place_khan(NX,NY).









 * Prédicat qui demande à un joueur de choisir une pièce puis lui demande via le prédicat 
 * ask_movement_to_player où il veut la placer



ask_movement_to_player(Player) :-
		pawnList(FullPawnList), % utile dans le cas où le joueur n'a aucune pièce présente sur une case du même type que celle du Khan
		get_unused_player_pawns(Player, UnusedPawnList), % utile dans le cas où le joueur possède des sbires qu'il peut remettre en jeu
		get_used_player_pawns(Player, UsedPawnList), % liste des pions du joueur qui sont sur le plateau
		get_possible_pawn(Player, UsedPawnList, PossiblePawnList_Tmp), % PossiblePawnList_Tmp contiendra la liste des pions du joueur qui sont sur une case du même type que la case actuelle du Khan
		length(PossiblePawnList_Tmp,NumberOfPossiblePawns), % récupérer la longueur de la liste PossiblePawnList_Tmp
		(NumberOfPossiblePawns =:= 0 % dans le cas où celle liste est vide, cela veut dire que le joueur n'a aucune pièce présente sur une case du même type que celle du Khan
			-> union([], FullPawnList, PossiblePawnList) % alors il peut jouer l'ensemble de ses pièces, qu'elles soient présentes où non sur le plateau
			; union([], PossiblePawnList_Tmp, PossiblePawnList) % sinon on unifie PossiblePawnList avec PossiblePawnList_Tmp et une liste vide
		),
		nl, writeWithPlayerColor('Joueur ', Player), writeWithPlayerColor(Player, Player), writeWithPlayerColor(' --> ', Player),
		write("Pièces possibles : "), writeWithPlayerColor(PossiblePawnList, Player), write(" (entrez le nom de celle que vous voulez jouer {'S1', ..., 'K'} ENTRE SIMPLES GUILLEMETS)"), nl,
		read(Pawn),
		

		(member_one_occurence(Pawn, PossiblePawnList) % dans le cas où la pièce entrée est dans la liste des pièces possibles

			-> 	(member_one_occurence(Pawn, UnusedPawnList) % dans le cas où il choisit un pion hors du jeu pour le remettre en jeu
				
				->	get_all_cells_according_to_khan_cell_value(MoveList), % la MoveList devient l'ensemble des cases du plateau libres et ayant la même valeur que la case sur laquelle est le khan
					ask_pawn_new_placement(MoveList,Pawn,Player) % prédicat spécial lorsqu'on remet la pièce sur le plateau pour ne pas supprimer les positions de toutes les autres pièces présentes sur le plateau


				;	pawn(I, J, Pawn, Player), % avoir les coordonnées I et J
					get_cell_value(I, J, CellValue), % récupérer la valeur de la case, puis l'ensemble des coups possibles et demander au joueur où il veut placer sa pièce
					setof(ML, possible_moves(I,J,Player,CellValue,[(I,J)],ML), ML),
					flatten(ML, MoveList),
					ask_pawn_new_position(I,J,MoveList,Pawn,Player)
				)
			; 	writeInRed('Vous ne pouvez pas jouer cette pièce, recommencez SVP.'),
				ask_movement_to_player(Player),!
		).
*/
