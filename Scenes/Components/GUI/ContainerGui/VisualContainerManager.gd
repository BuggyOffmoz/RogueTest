extends Control

class_name VisualContainerManager

@export var GUI : CanvasLayer
@export var container_manager : ContainerManager
@export var map_component : MapComponent

var all_containers : Array[ContainerSlotSystem]

func _ready():
	
	base_configurations()

func verify_items_in_cell():
	var player_pos = map_component.player.global_position
	var is_item_in_cells = map_component.level_data.verify_items_in_cell(player_pos)
	#if is_item_in_cells:
	GUI.item_icon.visible = is_item_in_cells
#func verify_containers_in_room():
	#if map_component.level_data.verify_containers_in_room(map_component.player.global_position):
		#var containers_in_room : Array = map_component.level_data.get_containers_in_room(map_component.player.global_position)
		#for container in containers_in_room:
		#	
		#	create_new_container_button(container)
	#else:
	#	reset_buttons()
	#container_manager.clear_containers()

func base_configurations():
	pass

func reset_buttons():
	var i := 1
	var base_child_amount := %ButtonContent.get_children().size()
	if %ButtonContent.get_children().size() > 1:
		for x in %ButtonContent.get_children():
			%ButtonContent.get_children()[i].queue_free()
			i += 1
			i = clamp(i,0,base_child_amount - 1)
		


#func create_new_container_button(_container:ContainerSlotSystem):
	#
	#var new_button = %SampleButton.duplicate() as Button
	#
	#new_button.connect("pressed",insert_container_in_center_gui_panel.bind(_container))
	#new_button.visible = true
	#
	#%ButtonContent.add_child(new_button)


func insert_container_in_center_gui_panel():
	var player_pos = map_component.player.global_position
	var new_container : Array = \
	map_component.level_data.get_containers_in_room(player_pos)
	if new_container != []:
		container_manager.add_container(new_container[0])
		container_manager.update_item_in_containers()

func _on_ground_container_pressed():
	pass # Replace with function body.
