


% removeHeadOfList(HeadWanted, List, NewListWithoutHead)
removeHeadOfList(T, [T|Q], Q).

% copy list L in list R
copy(L,R) :- accCp(L,R).
accCp([],[]).
accCp([H|T1],[H|T2]) :- accCp(T1,T2).



/*
 * Avoir un élément à la position N dans une liste
 *	element_position_n(PositionVoulue, Liste, ElementRetourne)
 */
element_position_n(1, [T|_], T) :- !.
element_position_n(N, [_|Q], T) :- M is N-1, element_position_n(M, Q, T).


member_one_occurence(X,[X|_]) :- !.
member_one_occurence(X,[_|Q]) :- member_one_occurence(X,Q).