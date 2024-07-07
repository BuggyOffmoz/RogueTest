extends Control

class_name ContainerManager

const SLOT = preload("res://Scenes/Components/GUI/ContainerSlotSystem.tscn")


### Nodos para usar
@export var player_container : ContainerSlotSystem
@export var map_component : MapComponent
@export var visual_container : VisualContainerManager

### Variables
var actual_containers : Array[ContainerSlotSystem]

@onready var order_system = get_node("Vertically")

func _ready():
	map_component.connect('MapGenerated', initialize_container)
	GameState.connect('EnemyDefeated', create_container_from_enemy)
	
func initialize_container():
	create_empty_containers()
	
func create_empty_containers():
	for i in map_component.get_empty_cells():
		var new_container = SLOT.instantiate()
		new_container.container_name = 'Floor'
		
		#add_random_items(new_container)
		
		map_component.level_data.add_container_to_room(new_container,i)
		
func add_random_items(new_container):
	var alt = load("res://Resources/Resources/InventoryResources/AllItems.tres")
	var _items_inside = [alt.all_items.pick_random()]
	for item:InventoryItem in _items_inside:
		if item as InventoryItem:
			var amount := 1
			if (_items_inside.find(item) + 1) is int:
				amount = _items_inside.find(item) + 1
			new_container.try_add_item(item,amount)
			
	return new_container

func add_container(_new_container:ContainerSlotSystem):
	actual_containers.clear() ## Limpiar containers para volver a mostrar solo 1
	if not actual_containers.has(_new_container):
		actual_containers.append(_new_container)
		
		_new_container.container_manager = self
		#print(name + ": Add container")
		if visible and !order_system.get_children().has(_new_container):
			order_system.add_child(_new_container)

func create_container_from_enemy(_enemy:EnemyBase):
	var _enemy_data = _enemy.enemy_data
	#var alt = load("res://Resources/Resources/InventoryResources/AllItems.tres")
	#create_specific_container_in_room([alt.all_items.pick_random()])
	create_specific_container_in_room([_enemy_data.items_dropeables.pick_random()])
	visual_container.verify_items_in_cell()

func create_specific_container_in_room(_items_inside:Array[InventoryItem]):
	#var new_container = SLOT.instantiate()
	#new_container.container_name = _name_container
	map_component.level_data.add_items_to_cell(_items_inside, \
	map_component.player.global_position)

func update_item_in_containers():
	for container in actual_containers:
		container.actualize_show_all_inventory()

func clear_containers():
	for container in order_system.get_children():
		if container is ContainerSlotSystem and container.container_name != "Player Inventory":
			order_system.remove_child(container)

func hind_container():
	pass

func show_container():
	if not GameState.COMBAT:
		pass
	else:
		visible = !visible 

