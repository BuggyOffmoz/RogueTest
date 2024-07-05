extends Node

signal ChangeState(state)
signal StartCombat(enemies)
signal CombatFinished

signal EnemyOnAttack(attack)
signal EnemyDefeated(enemy)

signal PlayerDead

enum {MOVE, COMBAT}
var game_state : int = MOVE

func restart_game():
	var path = get_tree().current_scene.scene_file_path
	game_state = MOVE
	get_tree().change_scene_to_file(path)

func change_state(state : int):
	game_state = state
	ChangeState.emit(state)
	
func start_combat(enemies : Array[EnemyData]):
	game_state = COMBAT
	ChangeState.emit(COMBAT)
	StartCombat.emit(enemies)
	
func enemy_attack(enemy_data : EnemyData): ## Probablemenbte en un futuro tenga que ser un Item Class
	EnemyOnAttack.emit(enemy_data)
	
func player_dead():
	PlayerDead.emit()
	
func combat_finished():
	game_state = MOVE
	ChangeState.emit(MOVE)
	CombatFinished.emit()

func enemy_defeated(enemy : EnemyData):
	EnemyDefeated.emit(enemy)
