extends Node2D
class_name Player

signal OnExitLevel

@export var tilemap : MapComponent

var input_vector : Vector2 = Vector2.ZERO

func _ready():
	pass
	
func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_right"):
		input_vector.x = 1
	elif Input.is_action_just_pressed("ui_left"):
		input_vector.x = -1
	elif Input.is_action_just_pressed("ui_up"):
		input_vector.y = -1
	elif Input.is_action_just_pressed("ui_down"):
		input_vector.y = 1
	else:
		input_vector = Vector2.ZERO
	
	if input_vector != Vector2.ZERO:
		move_player()
		
func move_player():
	var x = tilemap.tile_map.tile_set.tile_size.x
	var y = tilemap.tile_map.tile_set.tile_size.y
	var new_pos = global_position + (Vector2(x, y) * input_vector)
	
	var next_cell = tilemap.tile_map.local_to_map(new_pos)
	var cell_type = get_cell_type(next_cell)
	if cell_type != '':
		## Interaction ##
		if cell_type == 'exit':
			OnExitLevel.emit()
		return
	global_position = new_pos

func get_cell_type(cell_pos : Vector2i) -> String:
	var cell_atlas_coord = tilemap.tile_map.get_cell_atlas_coords(0, cell_pos)
	if cell_atlas_coord == Vector2i(-1,-1):
		return "obstacle"
	else:
		var tile_type = tilemap.tile_map.get_cell_tile_data(0, cell_pos).get_custom_data('type')
		return tile_type
