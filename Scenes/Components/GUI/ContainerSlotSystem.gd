extends Control

class_name ContainerSlotSystem

# Nodes:
@onready var dynamic_box_container = %DynamicBoxContainer as GridContainer

var item_inventory : Array[VisualInventoryItem]

var item_in_movement := false
var item_picked : VisualInventoryItem

func _ready():

	for x in 100:
		var n = load("res://Resources/Resources/InventoryResources/AllItems.tres").all_items.pick_random()
		
		try_add_item(n,1)
	

	
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
				#item.actualize_inventory_item()
				
				
				return
			
			# pero si ningun slot contiene el item enviado, se creara uno nuevo
		
		create_new_slot(_item,_amount)
	else:
		
		create_new_slot(_item,_amount)

func create_new_slot(_item:InventoryItem,_amount:int):
	
	var new_visual_slot = load("res://Scenes/Components/GUI/VisualInventoryItem.tscn").instantiate() as VisualInventoryItem
	
	new_visual_slot.inventory = self
	
	new_visual_slot.internal_item = _item
	
	new_visual_slot.item_amount = _amount
	
	item_inventory.append(new_visual_slot)
	dynamic_box_container.call_deferred("add_child",new_visual_slot)
	
	
	dynamic_box_container.queue_redraw()
	queue_redraw()
	#dynamic_box_container.verify_h_size()

func try_change_item_positions(_child_index:int):
	dynamic_box_container.move_child(item_picked,_child_index)

func try_erase_item(_item:InventoryItem,_amount:int):
	pass


func verify_item_amount(_item:InventoryItem,_amount:int):
	pass

