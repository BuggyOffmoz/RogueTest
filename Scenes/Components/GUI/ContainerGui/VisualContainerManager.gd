extends Control



var all_containers : Array[ContainerSlotSystem]

func _ready():
	
	base_configurations()


func base_configurations():
	var list_of_items = {
		load("res://Resources/Resources/InventoryResources/AllItems.tres").all_items.pick_random() : 5,
	}
	
	create_new_container(list_of_items,"Ground Container")



func create_new_container(_items_inside:Dictionary,_container_name:String):
	
	var new_container = load("res://Scenes/Components/GUI/ContainerSlotSystem.tscn").instantiate()

	new_container.container_name = _container_name
	all_containers.append(new_container)
	insert_container_in_center_gui_panel(new_container)
	for item in _items_inside:
		new_container.try_add_item(item,_items_inside[item])

func insert_container_in_center_gui_panel(new_container:ContainerSlotSystem):
	get_tree().get_nodes_in_group("ContainerManager")[0].add_container(new_container)




func _on_ground_container_pressed():
	pass # Replace with function body.
