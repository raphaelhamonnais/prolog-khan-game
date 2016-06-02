writeWithPlayerColor(X, Player) :- 	Player = 1,
									ansi_format([bold,fg(red)], '~w', [X]),!.
writeWithPlayerColor(X, Player) :- 	Player = 2,
									ansi_format([bold,fg(green)], '~w', [X]),!.
writeWithPlayerColor(X, Player) :- 	ansi_format([bold,fg(white)], '~w', [X]),!.