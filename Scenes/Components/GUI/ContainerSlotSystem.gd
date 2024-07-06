extends Control

class_name ContainerSlotSystem

# Nodes:
@onready var dynamic_box_container = %DynamicBoxContainer as GridContainer
@onready var mouse_container_detector = $MouseContainerDetector as Control
@export var container_manager : ContainerManager
var action_manager : ActionsManager

@export var container_name := "Unamed inventory"
var container_icon : Texture2D

var item_inventory : Array[VisualInventoryItem]

var item_in_movement := false
var item_picked : VisualInventoryItem

var mouse_here := false

func _ready():
	%ContainerName.text = container_name

func _input(event):
	if event.is_action_released("item_normal_action"):
		verify_other_containers_items_movements()

func try_add_item(_item:InventoryItem,_amount:int):
	if item_inventory.size() != 0:
		for item in item_inventory:
			# Verifico si el item enviado esta dentro del inventario
			
			if item.internal_item.item_id == _item.item_id:
				
				# si lo es, pero no es consumible (es decir, no se puede stackear) se creara una nueva ranura
				if not item.internal_item.consumable:
					create_new_slot(_item,_amount)
					return
				
				# si es consumible, se añadira al slot la cantidad enviada
				
				item.item_amount += _amount
				
				if container_manager.visible:
					item.actualize_inventory_item()
				
				
				return
			
			# pero si ningun slot contiene el item enviado, se creara uno nuevo
		
		create_new_slot(_item,_amount)
	else:
		#print("")
		create_new_slot(_item,_amount)

func actualize_show_all_inventory():
	for visual_slot: VisualInventoryItem in item_inventory:
		if dynamic_box_container.get_children().has(visual_slot):
			return
		dynamic_box_container.call_deferred("add_child",visual_slot)
		

func erase_all_visual_item():
	for visual_slot: VisualInventoryItem in item_inventory:
		#print(name + ": Erase Items")
		visual_slot.queue_free()

func create_new_slot(_item:InventoryItem,_amount:int):
	
	var new_visual_slot = load("res://Scenes/Components/GUI/VisualInventoryItem.tscn").instantiate() as VisualInventoryItem
	
	new_visual_slot.inventory = self
	
	new_visual_slot.internal_item = _item
	
	new_visual_slot.item_amount = _amount
	
	item_inventory.append(new_visual_slot)
	# TO FIX volver a des-comentar
	if container_manager != null and container_manager.visible:
		dynamic_box_container.call_deferred("add_child",new_visual_slot)
	
	
	#dynamic_box_container.queue_redraw()
	#queue_redraw()
	#dynamic_box_container.verify_h_size()

func try_change_item_positions(_child_index:int):
	dynamic_box_container.move_child(item_picked,_child_index)


func try_erase_item(_item:InventoryItem,_amount:int,_visual_item: VisualInventoryItem = null):
	for visual_item:VisualInventoryItem in dynamic_box_container.get_children():
		if visual_item.internal_item == _item and _visual_item == visual_item:
			_visual_item.queue_free()
			item_inventory.erase(_visual_item)


func verify_item_amount(_item:InventoryItem,_amount:int):
	pass

func verify_other_containers_items_movements():
	if not item_in_movement:
		for container:ContainerSlotSystem in get_tree().get_nodes_in_group("ContainerGroup"):
			if container.item_in_movement and container != self and mouse_here:
				try_add_item(container.item_picked.internal_item,container.item_picked.item_amount)
				container.try_erase_item(container.item_picked.internal_item,container.item_picked.item_amount,container.item_picked)

func _on_mouse_entered():
	mouse_here = true

func _on_mouse_exited():
	mouse_here = false
