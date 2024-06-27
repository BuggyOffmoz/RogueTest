extends Node

class_name Pathfinder

var start := Vector2(0, 0)
var end := Vector2(3, 4)
var path = []
var astar_map = AStarMap.new()

func set_path(game_map):
	astar_map.set_map(game_map)

func update_path(game_map, from, to):
	start = game_map.local_to_map(from)
	end = game_map.local_to_map(to)#.position)
	path = astar_map.astar_grid.get_id_path(start, end)
	return path
	
func update_static_path(game_map, objetive, enemy):
	start = game_map.local_to_map(enemy.position)
	path = astar_map.astar_grid.get_id_path(start, objetive)
	return path

func create_line(line, _path):
	line.clear_points()
	#line.default_color = Color(1, 0, 0)
	#line.width = 2
	
	for i in range(_path.size() - 1):
		var start_pos = astar_map.astar_grid.get_point_position(_path[i])
		var end_pos = astar_map.astar_grid.get_point_position(_path[i + 1])
		line.add_point(start_pos)
		line.add_point(end_pos)
