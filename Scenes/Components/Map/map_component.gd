extends Node
class_name MapComponent

signal MapGenerated

@onready var tile_map : TileMap = $TileMap
@onready var player : Player = $Player
@export var visual_container : VisualContainerManager

@export var level_data : LevelData

@export var map_size : Vector2i = Vector2i(7,7)
@export var start_end_distance : int = 6
@export var wall_density : int = 14

@export_category("Elements")
@export var max_enemies : int = 7
@export var min_enemies : int = 2
## Probabilities ##
@export var boss_probability : float = 20.0
@export var treasure_probability : float = 20.0
@export var max_treasures : int = 3
@export var min_tresures : int = 0
######

@export_category("Environment")
@export var fog : Node2D

@export_category("DEBUG")
@export var line_debug : Line2D

## TILESET ATLAS COORDS ##
var ground_atlas_coord : Vector2i = Vector2i(1,1)
var initial_atlas_coord : Vector2i = Vector2i(0,1)
var exit_atlas_coord : Vector2i = Vector2i(1,0)
var wall_atlas_coord : Vector2i = Vector2i(0,0)
var enemies_atlas_coord : Vector2i = Vector2i(2,1)
##########################

var layer : int = 0

var initial_position : Vector2 = Vector2.ZERO
var exit_position : Vector2 = Vector2.ZERO

var path_finder = Pathfinder.new()
var map_generated : bool = false


func can_spawn_object(probability):
	var random_value = randi() % 100
	return random_value < probability

func _ready():
	GameState.connect('CombatFinished', combat_finished)
	randomize()
	create_random_map()
	
func _process(_delta):
	if !map_generated:
		create_random_map()
	else:
		set_process(false)
		fog.initialize_fog()
		MapGenerated.emit()
		
func map_initialize():
	map_generated = false
	set_process(true)
	
func create_random_map():
	for x in map_size.x:
		for y in map_size.y:
			tile_map.set_cell(0, Vector2i(x,y), 0, ground_atlas_coord)
			
	if wall_density > (map_size.x * map_size.y) - 4:
		wall_density = map_size.x * 3
	
	create_in_out()
	create_walls()
	var entities = create_enemies()
	entities.append(exit_position)
	for i in entities:
		map_generated = check_path(initial_position, i)
		if map_generated == false:
			break
	
	player.global_position = initial_position
	
func create_enemies() -> Array:
	var enemies_pos = []
	var used_cells : Array = tile_map.get_used_cells(layer)
	var cells_availables : Array = []
	for i in used_cells:
		var used_coord = tile_map.get_cell_atlas_coords(0, i)
		if used_coord == ground_atlas_coord:
			cells_availables.append(i)
	
	var enemies : int = randi_range(min_enemies, max_enemies)
	for enemy in enemies:
		var idx = randi_range(0, cells_availables.size()-1)
		tile_map.set_cell(0, cells_availables[idx], 0, enemies_atlas_coord)
		enemies_pos.append(tile_map.map_to_local(cells_availables[idx]))
		cells_availables.remove_at(idx)
	return enemies_pos
	
func check_path(from, to) -> bool:
	var line_path : Array = []
	path_finder.set_path(tile_map)
	line_path = path_finder.update_path(tile_map, from, to)
	path_finder.create_line(line_debug, line_path)
	if line_path.size() > 0:
		#create_random_map()
		return true
	else:
		return false

func create_walls():
	var used_cells : Array = tile_map.get_used_cells(layer)
	var cells_availables : Array = []
	for i in used_cells:
		var used_coord = tile_map.get_cell_atlas_coords(0, i)
		if used_coord == ground_atlas_coord:
			cells_availables.append(i)
	
	var max_walls : float = roundi(wall_density)
	for wall in max_walls:
		var idx = randi_range(0, cells_availables.size()-1)
		tile_map.set_cell(0, cells_availables[idx], 0, wall_atlas_coord)
		cells_availables.remove_at(idx)
			
func create_in_out():
	var random_out := Vector2i.ZERO
	var random_in := Vector2i.ZERO
	while abs(random_in - random_out) < Vector2i(start_end_distance, start_end_distance):
		random_out = get_random_border_cell()
		random_in = get_random_border_cell()
	tile_map.set_cell(0, random_out, 0, exit_atlas_coord)
	tile_map.set_cell(0, random_in, 0, Vector2i(0,1))
	
	initial_position = tile_map.map_to_local(random_in)
	exit_position = tile_map.map_to_local(random_out)
	
func get_random_border_cell() -> Vector2i:
	var border_cells = get_border_cells()
	var idx : int = randi_range(0, border_cells.size() - 1)
	var random_pos = border_cells[idx]
	
	return random_pos
	
func get_border_cells() -> Array:
	var used_cells : Array = tile_map.get_used_cells(layer)
	var border_cells : Array = []
	
	for i in used_cells:
		if i.x == 0 or i.x == (map_size.x - 1):
			border_cells.append(i)
		elif i.y == 0 or i.y == (map_size.y - 1):
			border_cells.append(i)
	return border_cells
	
func get_limits() -> Vector2:
	var tile_rect = tile_map.get_used_rect()
	var size = tile_map.map_to_local(tile_rect.size)
	return size
	
func get_empty_cells() -> Array[Vector2]:
	var arr : Array[Vector2] = []
	var cells = tile_map.get_used_cells(0)
	for i in cells:
		if tile_map.get_cell_tile_data(0,i).get_custom_data('type') != 'obstacle':
			arr.append(tile_map.map_to_local(i))
	return arr
	
### DEBUG ###
#func _input(_event):
	#if Input.is_action_just_pressed("debug_button"):
		#GameState.change_state(GameState.MOVE)
		#map_initialize()
#############


## SIGNALS ##
func _on_player_on_exit_level():
	map_initialize()
	
func move_right_button():
	player.input_vector.x = 1
	player.move_player()
func move_left_button():
	player.input_vector.x = -1
	player.move_player()
func move_up_button():
	player.input_vector.y = -1
	player.move_player()
func move_down_button():
	player.input_vector.y = 1
	player.move_player()

func combat_finished():
	#var cells = tile_map.get_used_cells(0)
	var enemy_cell = tile_map.local_to_map(player.position)
	tile_map.set_cell(0, enemy_cell, 0, ground_atlas_coord)
