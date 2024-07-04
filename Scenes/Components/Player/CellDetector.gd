extends Node
class_name CellDetector

@export var player : Player
@export var map_component : MapComponent

func cell_interactions(cell_type : String):
	## Interaction ##
	if cell_type == 'exit':
		player.OnExitLevel.emit()
	elif cell_type == 'enemy':
		#GameState.change_state(GameState.COMBAT)
		GameState.start_combat(get_enemies_in_cell())
	
		
func get_enemies_in_cell() -> Array[EnemyData]:
	var enemies = map_component.level_data.enemies_type.duplicate() ### En un futuro hay que crear una función que eliga una cantidad aleatoria de enemigos.
	return enemies
