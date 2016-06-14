




human_vs_human_game_loop(Player) :-
		ask_movement_to_player(Player),
		get_other_player(Player, OtherPlayer),
		(player_win(Player)
			-> 	writeWithPlayerColor('Bravo joueur ', Player),
				writeWithPlayerColor(Player,Player),
				writeWithPlayerColor(', vous avez gagné !!!',Player),nl
			;	human_vs_human_game_loop(OtherPlayer)
		).
		


human_vs_human_launch_game() :-
		player1(Player_1),player2(Player_2), % avoir les valeurs numériques correspondantes au joueur 1 et 2
		human_vs_human_game_loop(Player_1).



player_win(Player) :-
		get_other_player(Player,OtherPlayer),
		get_unused_player_pawns(OtherPlayer, UnusedPawnList),
		member('K',UnusedPawnList),!.



