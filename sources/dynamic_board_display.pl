%% Base de faits dynamiques temporaires %%
:-dynamic(i/1).
:-dynamic(j/1).

/*:-dynamic(s1j1/4).
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
:-dynamic(kj2/4).*/

:-dynamic(pawn/4).

init_dynamic_fact() :- 	reset_pawn(),
			/*			asserta(s1j1('S', 1, 0,0)),
						asserta(s2j1('S', 1, 0,1)),
						asserta(s3j1('S', 1, 0,2)),
						asserta(s4j1('S', 1, 0,3)),
						asserta(s5j1('S', 1, 0,4)),
						asserta(kj1('K', 1, 0,5)),
						asserta(s1j2('S', 2, 5,0)),
						asserta(s2j2('S', 2, 5,1)),
						asserta(s3j2('S', 2, 5,2)),
						asserta(s4j2('S', 2, 5,3)),
						asserta(s5j2('S', 2, 5,4)),
						asserta(kj2('K', 2, 5,5)),*/
						reset_index().

reset_index():- retractall(i(_)), retractall(j(_)), asserta(i(0)), asserta(j(0)).
reset_pawn():- 	retractall(s1j1(_, _, _, _)),
				retractall(s2j1(_, _, _, _)),
				retractall(s3j1(_, _, _, _)),
				retractall(s4j1(_, _, _, _)),
				retractall(s5j1(_, _, _, _)),
				retractall(kj1(_, _, _, _)),
				retractall(s1j2(_, _, _, _)),
				retractall(s2j2(_, _, _, _)),
				retractall(s3j2(_, _, _, _)),
				retractall(s4j2(_, _, _, _)),
				retractall(s5j2(_, _, _, _)),
				retractall(kj2(_, _, _, _)).

dynamic_display([]).
dynamic_display([[T|Q1]|Q2]):- 	dynamic_display([T|Q1]),
						asserta(j(0)),
						nl,
						i(I),
						NI is I+1,
						asserta(i(NI)),
						dynamic_display(Q2),
						!.
						
dynamic_display([T|Q]):- i(I),
						j(J),
						pawn(I, J, Pawn, Player),
						!,
						write(T),
						write('-'),
						writeWithPlayerColor(Pawn, Player),
						write(' '),
						NJ is J+1,
						asserta(j(NJ)),
						dynamic_display(Q),
						!.

dynamic_display([T|Q]):- i(I),
						j(J),
						write(T),
						write('-'),
						write('_'),
						write(' '),
						NJ is J+1,
						asserta(j(NJ)),
						dynamic_display(Q),
						!.

/*pawn(X, Y, Pawn, Player) :-	s1j1(Pawn, Player, X, Y), !.
pawn(X, Y, Pawn, Player) :-	s2j1(Pawn, Player, X, Y), !.
pawn(X, Y, Pawn, Player) :-	s3j1(Pawn, Player, X, Y), !.
pawn(X, Y, Pawn, Player) :-	s4j1(Pawn, Player, X, Y), !.
pawn(X, Y, Pawn, Player) :-	s5j1(Pawn, Player, X, Y), !.
pawn(X, Y, Pawn, Player) :-	kj1(Pawn, Player, X, Y), !.
pawn(X, Y, Pawn, Player) :-	s1j2(Pawn, Player, X, Y), !.
pawn(X, Y, Pawn, Player) :-	s2j2(Pawn, Player, X, Y), !.
pawn(X, Y, Pawn, Player) :-	s3j2(Pawn, Player, X, Y), !.
pawn(X, Y, Pawn, Player) :-	s4j2(Pawn, Player, X, Y), !.
pawn(X, Y, Pawn, Player) :-	s5j2(Pawn, Player, X, Y), !.
pawn(X, Y, Pawn, Player) :-	kj2(Pawn, Player, X, Y), !.
pawn(_, _, '_', 0).*/