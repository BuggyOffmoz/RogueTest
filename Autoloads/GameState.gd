extends Node

signal ChangeState(state)
signal StartCombat(enemies)

enum {MOVE, COMBAT}
var game_state : int = MOVE

func change_state(state : int):
	game_state = state
	ChangeState.emit(state)
	
func start_combat(enemies : Array[EnemyData]):
	game_state = COMBAT
	ChangeState.emit(COMBAT)
	StartCombat.emit(enemies)
