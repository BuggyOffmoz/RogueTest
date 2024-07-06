extends Resource

class_name LevelData

@export var enemies_type : Array[EnemyData]

@export var enemies_in_scene : Array[EnemyData]

@export var containers_in_scene : Dictionary

func add_items_to_cell(_items_inside : Array[InventoryItem], _player_position:Vector2i):
	if containers_in_scene.has(_player_position):
		print('LevelData.gd: Add Items')
		var new_container = containers_in_scene.get(_player_position)[0]
		for item:InventoryItem in _items_inside:
			if item as InventoryItem:
				var amount := 1
				if (_items_inside.find(item) + 1) is int:
					amount = _items_inside.find(item) + 1
				new_container.try_add_item(item,amount)
		containers_in_scene[_player_position][0] = new_container
		return
	else:
		print("Error: Cell Not Founded")

func add_container_to_room(_container:ContainerSlotSystem,_player_position:Vector2i):
	
	## Verifico si en esa misma posicion ya existe un array de contenedores
	
	if containers_in_scene.has(_player_position):
		#print("LevellData.gd: " + "Container Reemplazado")
		containers_in_scene[_player_position] = [_container]
		
		### si los hay, recorro el array de contenedores
		#for array_container in containers_in_scene.values():
			#for container:ContainerSlotSystem in array_container:
				### y verifico si los nombres coinciden, si lo hacen, combino los ambos contenedores
				### para tener solo uno
				#if _container.container_name == container.container_name:
					#print("add")
					#container.item_inventory += _container.item_inventory
					#print(get_containers_in_room(_player_position)[0].item_inventory)
					#return
		### si el contenedor no existe por default, añadire uno nuevo al array
		#containers_in_scene[_player_position].append(_container)
		
	else:
		#print('LevelData.gd: Add Container')
		## si no hay contenedores en esa posicion, creo un nuevo array de contenedores
		containers_in_scene[_player_position] = [_container]

func get_containers_in_room(_player_position:Vector2i) -> Array:
	return(containers_in_scene.get(_player_position))

func verify_containers_in_room(_player_position:Vector2i) -> bool:
	
	if containers_in_scene.has(_player_position):
		return(true)
	else:
		return(false)
