player_win(Player) :-
		get_other_player(Player, OtherPlayer),
		get_unused_player_pawns(OtherPlayer, UnusedPawnList),
		member('K',UnusedPawnList),!.

human_vs_human_game_loop(Player) :-
		ask_movement_to_player(Player),
		get_other_player(Player, OtherPlayer),
		(player_win(Player)
			-> 	writeWithPlayerColor('Bravo joueur ', Player),
				writeWithPlayerColor(Player,Player),
				writeWithPlayerColor(', vous avez gagne !!!',Player),nl
			;	human_vs_human_game_loop(OtherPlayer)
		).
		
human_vs_human_launch_game() :-
		player1(Player_1),player2(Player_2), % avoir les valeurs numeriques correspondantes au joueur 1 et 2
		human_vs_human_game_loop(Player_1).





human_vs_machine_game_loop(JoueurActif) :-
	get_other_player(JoueurActif, JoueurAdverse),
	(JoueurActif =:= 1
		->	ask_movement_to_player(JoueurActif)
		;	joue(JoueurActif, JoueurAdverse, 3)
	),
	(player_win(JoueurActif)
		-> 	writeWithPlayerColor('Bravo joueur ', JoueurActif),
			writeWithPlayerColor(JoueurActif, JoueurActif),
			writeWithPlayerColor(', vous avez gagne !!!', JoueurActif), nl
		;	human_vs_machine_game_loop(JoueurAdverse)
	).

human_vs_machine_launch_game() :-
	player1(Joueur1),
	player2(Joueur2),
	human_vs_machine_game_loop(Joueur1).




machine_vs_machine_game_loop(JoueurActif) :-
	get_other_player(JoueurActif, JoueurAdverse),
	joue(JoueurActif, JoueurAdverse, 3),
	(player_win(JoueurActif)
		-> 	writeWithPlayerColor('Bravo joueur ', JoueurActif),
			writeWithPlayerColor(JoueurActif, JoueurActif),
			writeWithPlayerColor(', vous avez gagne !!!', JoueurActif), nl
		;	machine_vs_machine_game_loop(JoueurAdverse)
	).

machine_vs_machine_launch_game() :-
	player1(Joueur1),
	player2(Joueur2),
	machine_vs_machine_game_loop(Joueur1).