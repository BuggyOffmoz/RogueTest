extends Node

signal ChangeState(state)

enum{MOVE, COMBAT}
var game_state : int = MOVE

func change_state(state : int):
	game_state = state
	ChangeState.emit(state)
