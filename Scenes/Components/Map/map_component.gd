extends Node2D
class_name MapComponent

@onready var tile_map : TileMap = $TileMap
@onready var player : Player = $Player

@export var map_size : Vector2i = Vector2i(7,7)
@export var start_end_distance : int = 6
@export var wall_density : int = 14

@export_category("DEBUG")
@export var line_debug : Line2D

var ground_atlas_coord : Vector2i = Vector2i(1,1)
var initial_atlas_coord : Vector2i = Vector2i(0,1)
var exit_atlas_coord : Vector2i = Vector2i(1,0)
var wall_atlas_coord : Vector2i = Vector2i(0,0)
var path_atlas_coord : Vector2i = Vector2i(2,1)

var layer : int = 0

var initial_position : Vector2 = Vector2.ZERO
var exit_position : Vector2 = Vector2.ZERO

var path_finder = Pathfinder.new()
var map_generated : bool = false

func _ready():
	randomize()
	create_random_map()
	
func _process(_delta):
	if !map_generated:
		create_random_map()
	
func create_random_map():
	for x in map_size.x:
		for y in map_size.y:
			tile_map.set_cell(0, Vector2i(x,y), 0, ground_atlas_coord)
			
	if wall_density > (map_size.x * map_size.y) - 4:
		wall_density = map_size.x * 3
	
	create_in_out()
	create_walls()
	create_path()
	
	player.global_position = initial_position
	
func create_path():
	var line_path : Array = []
	path_finder.set_path(tile_map)
	line_path = path_finder.update_path(tile_map, initial_position, exit_position)
	path_finder.create_line(line_debug, line_path)
	if line_path.size() > 0:
		#create_random_map()
		map_generated = true

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
	
func _input(_event):
	if Input.is_action_just_pressed("debug_button"):
		map_generated = false
		#create_random_map()
