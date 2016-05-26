%% ===============================================================================
%% ============================ DISPLAY THE BOARD ================================
%% ===============================================================================
%% board
%%		    c
%%	  [3,1,2,2,3,1]
%%    [2,3,1,3,1,2]
%% d  [2,1,3,1,3,2]  b
%%    [1,3,2,2,1,3]
%%    [3,1,3,1,3,1]
%%    [2,2,1,3,2,2]
%%		    a
writeWithColor(X, Z) :- 	Z =:= 1,
							ansi_format([bold,fg(red)], X, Z),!.
writeWithColor(X, Z) :- 	Z =:= 2,
							ansi_format([bold,fg(blue)], X, Z),!.
writeWithColor(X, Z) :- 	ansi_format([bold,fg(black)], X, Z),!.



board_for_choose_side( [
				[' ', ' ', ' ',' ','c',' ',' ',' ',' ', ' '],
				[' ', ' ', 3,1,2,2,3,1,' ', ' '],
				[' ', ' ', 2,3,1,3,1,2,' ', ' '],
				['d', ' ', 2,1,3,1,3,2,' ', 'b'],
				[' ', ' ', 1,3,2,2,1,3,' ', ' '],
				[' ', ' ', 3,1,3,1,3,1,' ', ' '],
				[' ', ' ', 2,2,1,3,2,2,' ', ' '],
				[' ', ' ', ' ',' ','a',' ',' ',' ',' ', ' ']
			 ]).

displayList([]).
displayList([T|Q]) :- write(' '),
					writeWithColor(' ~w', [T]),
					 %write(T),
					 displayList(Q),!.


displayBoardClassic([]).
displayBoardClassic([T|Q]) :- displayList(T), nl, displayBoardClassic(Q).

displayBoardWithIndex([]).
displayBoardWithIndex([T|Q]) :- displayList(T), nl, displayBoardWithIndex(Q).

display_board_for_choose_side([]).
display_board_for_choose_side :- board_for_choose_side(X),
						displayBoardClassic(X), !.


%% ===============================================================================
%% ============================ CHOSSE BOARD DISPLAY =============================
%% ===============================================================================


chooseBoardDisplay('a', [[3,1,2,2,3,1],
					    [2,3,1,3,1,2],
					    [2,1,3,1,3,2],
					    [1,3,2,2,1,3],
					    [3,1,3,1,3,1],
					    [2,2,1,3,2,2]]
					).

chooseBoardDisplay('A', [[3,1,2,2,3,1],
					    [2,3,1,3,1,2],
					    [2,1,3,1,3,2],
					    [1,3,2,2,1,3],
					    [3,1,3,1,3,1],
					    [2,2,1,3,2,2]]
					).

chooseBoardDisplay('b', [[2,3,1,2,2,3],
						 [2,1,3,1,3,1],
						 [1,3,2,3,1,2],
						 [3,1,2,1,3,2],
						 [2,3,1,3,1,3],
						 [2,1,3,2,2,1]]
						).
chooseBoardDisplay('B', [[2,3,1,2,2,3],
						 [2,1,3,1,3,1],
						 [1,3,2,3,1,2],
						 [3,1,2,1,3,2],
						 [2,3,1,3,1,3],
						 [2,1,3,2,2,1]]
						).

chooseBoardDisplay('c', [[2,2,3,1,2,2],
						 [1,3,1,3,1,3],
						 [3,1,2,2,3,1],
						 [2,3,1,3,1,2],
						 [2,1,3,1,3,2],
						 [1,3,2,2,1,3]]
						).
chooseBoardDisplay('C', [[2,2,3,1,2,2],
						 [1,3,1,3,1,3],
						 [3,1,2,2,3,1],
						 [2,3,1,3,1,2],
						 [2,1,3,1,3,2],
						 [1,3,2,2,1,3]]
						).
chooseBoardDisplay('d', [[1,2,2,3,1,2],
						 [3,1,3,1,3,2],
						 [2,3,1,2,1,3],
						 [2,1,3,2,3,1],
						 [1,3,1,3,1,2],
						 [3,2,2,1,3,2]]
						).
chooseBoardDisplay('D', [[1,2,2,3,1,2],
						 [3,1,3,1,3,2],
						 [2,3,1,2,1,3],
						 [2,1,3,2,3,1],
						 [1,3,1,3,1,2],
						 [3,2,2,1,3,2]]
						).

:- dynamic (activeBoard/1).




%% ===============================================================================
%% ============================ ASK DISPLAY TO PLAYER ============================
%% ===============================================================================

askDisplayToPlayer(X) :- 	write('Please choose you side : a, b, c or d.'),
							nl,
							read(X).

initBoard() :- 	display_board_for_choose_side(),
				askDisplayToPlayer(VAL),
				chooseBoardDisplay(VAL, BOARD),
				retractall(activeBoard(_)),
				asserta(activeBoard(BOARD)),
				displayBoardWithIndex(BOARD),
				!.

displayActiveBoard() :- activeBoard(BOARD),
						displayBoardWithIndex(BOARD),
						!.



