:-dynamic(i/1).
:-dynamic(j/1).

reset():- retractall(i(_)), retractall(j(_)), asserta(i(0)), asserta(j(0)).

display([]).
display([[T|Q1]|Q2]):- 	display([T|Q1]),
						asserta(i(0)),
						nl,
						j(J),
						NJ is J+1,
						asserta(j(NJ)),
						display(Q2),
						!.
						
display([T|Q]):- 		i(I),
						j(J),
						pawn(I, J, P, Player),
						write(T),
						write('-'),
						write(P),
						write(' '),
						NI is I+1,
						asserta(i(NI)),
						display(Q),
						!.

pawn(X, Y, P, J) :-	s1j1(P, J, X, Y), !.
pawn(X, Y, P, J) :-	s2j1(P, J, X, Y), !.
pawn(X, Y, P, J) :-	s3j1(P, J, X, Y), !.
pawn(X, Y, P, J) :-	s4j1(P, J, X, Y), !.
pawn(X, Y, P, J) :-	s5j1(P, J, X, Y), !.
pawn(X, Y, P, J) :-	kj1(P, J, X, Y), !.
pawn(X, Y, P, J) :-	s1j2(P, J, X, Y), !.
pawn(X, Y, P, J) :-	s2j2(P, J, X, Y), !.
pawn(X, Y, P, J) :-	s3j2(P, J, X, Y), !.
pawn(X, Y, P, J) :-	s4j2(P, J, X, Y), !.
pawn(X, Y, P, J) :-	s5j2(P, J, X, Y), !.
pawn(X, Y, P, J) :-	kj2(P, J, X, Y), !.
pawn(_, _, '_', 0).

%% Base de faits statiques temporaires %%

s1j1('S', 1, 0,0).
s2j1('S', 1, 1,0).
s3j1('S', 1, 2,0).
s4j1('S', 1, 3,0).
s5j1('S', 1, 4,0).
kj1('K', 1, 5,0).
s1j2('S', 2, 0,5).
s2j2('S', 2, 1,5).
s3j2('S', 2, 2,5).
s4j2('S', 2, 3,5).
s5j2('S', 2, 4,5).
kj2('K', 2, 5,5).