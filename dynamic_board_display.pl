%% Base de faits dynamiques temporaires %%
:-dynamic(i/1).
:-dynamic(j/1).

:-dynamic(s1j1/4).
:-dynamic(s2j1/4).
:-dynamic(s3j1/4).
:-dynamic(s4j1/4).
:-dynamic(s5j1/4).
:-dynamic(kj1/4).
:-dynamic(s1j2/4).
:-dynamic(s2j2/4).
:-dynamic(s3j2/4).
:-dynamic(s4j2/4).
:-dynamic(s5j2/4).
:-dynamic(kj2/4).

init() :- 	asserta(s1j1('S', 1, 0,0)),
			asserta(s2j1('S', 1, 1,0)),
			asserta(s3j1('S', 1, 2,0)),
			asserta(s4j1('S', 1, 3,0)),
			asserta(s5j1('S', 1, 4,0)),
			asserta(kj1('K', 1, 5,0)),
			asserta(s1j2('S', 2, 0,5)),
			asserta(s2j2('S', 2, 1,5)),
			asserta(s3j2('S', 2, 2,5)),
			asserta(s4j2('S', 2, 3,5)),
			asserta(s5j2('S', 2, 4,5)),
			asserta(kj2('K', 2, 5,5)),
			reset().

reset():- retractall(i(_)), retractall(j(_)), asserta(i(0)), asserta(j(0)).

writeWithPlayerColor(X, Player) :- 	Player = 1,
									ansi_format([bold,fg(red)], '~w', [X]),!.
writeWithPlayerColor(X, Player) :- 	Player = 2,
									ansi_format([bold,fg(green)], '~w', [X]),!.
writeWithPlayerColor(X, Player) :- 	ansi_format([bold,fg(white)], '~w', [X]),!.

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
						writeWithPlayerColor(P, Player),
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