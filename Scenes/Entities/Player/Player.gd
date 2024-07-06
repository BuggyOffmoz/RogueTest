extends Node2D
class_name Player

signal OnExitLevel

@export var map_component : MapComponent
@export var cell_detector : CellDetector

var input_vector : Vector2 = Vector2.ZERO

func _ready():
	pass
	
func _physics_process(_delta):
	if Input.is_action_just_pressed("right"):
		input_vector.x = 1
		input_vector.y = 0
	elif Input.is_action_just_pressed("left"):
		input_vector.x = -1
		input_vector.y = 0
	elif Input.is_action_just_pressed("up"):
		input_vector.y = -1
		input_vector.x = 0
	elif Input.is_action_just_pressed("down"):
		input_vector.y = 1
		input_vector.x = 0
	else:
		input_vector = Vector2.ZERO
	
	if input_vector != Vector2.ZERO:
		move_player()
		
func move_player():
	if GameState.game_state != GameState.MOVE:
		return
	var x = map_component.tile_map.tile_set.tile_size.x
	var y = map_component.tile_map.tile_set.tile_size.y
	var new_pos = global_position + (Vector2(x, y) * input_vector)
	
	var next_cell = map_component.tile_map.local_to_map(new_pos)
	var cell_type = get_cell_type(next_cell)
	if cell_type != '':
		if cell_type == 'obstacle':
			return
		cell_detector.cell_interactions(cell_type)
		global_position = new_pos
		return
	global_position = new_pos

	visual_container_notificate()


## Añadido de Offmoz
func visual_container_notificate():
	if map_component.visual_container != null:
		map_component.visual_container.verify_containers_in_room()
##

func cell_interactions(cell_type : String):
	## Interaction ##
	if cell_type == 'exit':
		OnExitLevel.emit()
	elif cell_type == 'enemy':
		#GameState.change_state(GameState.COMBAT)
		GameState.start_combat(get_enemies_in_cell())
		
func get_enemies_in_cell() -> Array[EnemyData]:
	var enemies = map_component.level_data.enemies_in_scene ### En un futuro hay que crear una función que eliga una cantidad a leatoria de enemigos.
	return enemies


func get_cell_type(cell_pos : Vector2i) -> String:
	var cell_atlas_coord = map_component.tile_map.get_cell_atlas_coords(0, cell_pos)
	if cell_atlas_coord == Vector2i(-1,-1):
		return "obstacle"
	else:
		var tile_type = map_component.tile_map.get_cell_tile_data(0, cell_pos).get_custom_data('type')
		if tile_type == "enter":
			tile_type = ''
		return tile_type
