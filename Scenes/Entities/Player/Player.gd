extends Node2D
class_name Player

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
		var x = tilemap.tile_map.tile_set.tile_size.x
		var y = tilemap.tile_map.tile_set.tile_size.y
		var new_pos = global_position + (Vector2(x, y) * input_vector)
		
		var next_cell = tilemap.tile_map.get_cell_atlas_coords(0, tilemap.tile_map.local_to_map(new_pos))
		#var limit = tilemap.get_limits()
		if next_cell == Vector2i(-1,-1):
			return
		#if new_pos.x >= limit.x or new_pos.y >= limit.y:
		#	return
		#elif new_pos.x <= 0 or new_pos.y <= 0:
		#	return
		elif tilemap.tile_map.get_cell_atlas_coords(0, tilemap.tile_map.local_to_map(new_pos)) == Vector2i(0,0):
			return
		
		global_position = new_pos
