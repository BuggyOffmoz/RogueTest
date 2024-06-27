extends Node

class_name AStarMap

var astar_grid := AStarGrid2D.new()
var _half_cell_size
var start := Vector2.ZERO
var end := Vector2.ZERO

func set_map(game_map : TileMap):
	astar_grid.region.size = game_map.get_used_rect().size
	astar_grid.cell_size = game_map.tile_set.tile_size #Vector2(64, 64)
	
	_half_cell_size = astar_grid.cell_size / 2
	astar_grid.set_offset(_half_cell_size)
	astar_grid.update()
	
	astar_grid.diagonal_mode = astar_grid.DIAGONAL_MODE_NEVER
	
	for i in range(astar_grid.size.x):
		for j in range(astar_grid.size.y):
			var id = Vector2i(i, j)
			# If game_map does not have a cell source id >= 0
			# then we're looking at an invalid location
			if game_map.get_cell_source_id(0, id) >= 0:
				var tile_type = game_map.get_cell_tile_data(0, id).get_custom_data('type')
				astar_grid.set_point_solid(Vector2i(i, j), tile_type == 'obstacle')
