%% replace([_|T], 0, X, [X|T]) :- !.
%% replace([H|T], I, X, [H|R]):-   I > -1,
%%                                 NI is I-1,
%%                                 replace(T, NI, X, R), !.
%% replace(L, _, _, L).


replaceElement(_, _, [], []).
replaceElement(O, R, [O|T], [R|T2]) :- replaceElement(O, R, T, T2), !.
replaceElement(O, R, [H|T], [H|T2]) :- dif(H,O), replaceElement(O, R, T, T2).


%% removePieceFromBoard([], Piece, []).
removePieceFromBoard([],_,[]) :-
        fail, !.

removePieceFromBoard([OldLine|Q], Piece, [NewLine|Q]) :-
        member([Num,Piece], OldLine), % si la pièce est sur la ligne, c'est à dire qu'il y a une case égale à [Num,Piece] (où Num s'unifie avec la valeur de la case)
        !, % permet d'empêcher le backtracking sur les instructions qui suivent le !
        % chaque pièce est unique, donc replaceElement suffit : on remplace [Num,Piece] par Num, exemple [1,sr1] sera remplacé par 1 si Piece = sr1
        replaceElement([Num,Piece], Num, OldLine, NewLine). % NewLine prend donc la valeur de OldLine sans la pièce qu'on voulait enlever

% Inutile je pense
%% removePieceFromBoard([L|Ls], Piece, [SubListsWithout|Ls]):-
%%         \+ member(Piece,L), % si 
%%         removePieceFromBoard(L,Piece,SubListsWithout).

removePieceFromBoard([OldLine|Q], Piece, [OldLine|R]) :- 
        \+ member([Num,Piece], OldLine),
        removePieceFromBoard(Q, Piece, R), !.


