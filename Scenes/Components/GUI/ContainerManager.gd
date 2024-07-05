extends Control

class_name ContainerManager


### Nodos para usar
@export var player_container : ContainerSlotSystem


### Variables
var actual_containers : Array[ContainerSlotSystem]

@onready var order_system = get_node("Vertically")

func add_container(_new_container:ContainerSlotSystem):
	actual_containers.append(_new_container)
	
	_new_container.container_manager = self
	
	if not visible:
		order_system.add_child(_new_container)

func hind_container():
	pass

func show_container():
	if not GameState.COMBAT:
		pass
	else:
		visible = !visible 
		for container in actual_containers:
			container.actualize_show_all_inventory()
