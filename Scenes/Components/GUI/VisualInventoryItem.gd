extends Control

class_name VisualInventoryItem


var picked := false

# nodes
var inventory : ContainerSlotSystem

@onready var item_icon = $ItemIcon as TextureRect
@onready var visual_item_amount = $ItemAmount as Label


var item_amount := 0

var internal_item : InventoryItem

func _ready():
	actualize_inventory_item()

func actualize_inventory_item():
	if internal_item:
		item_icon.texture = internal_item.item_icon
		visual_item_amount.text = str(item_amount)



func _on_gui_input(event:InputEvent):
	if event.is_action_pressed("item_open_options") and not picked:
		pass
	
	if event.is_action_pressed("item_normal_action") and not picked:
		inventory.item_in_movement = true
		inventory.item_picked = self
		picked = true
	elif event.is_action_released("item_normal_action") and picked:
		inventory.item_in_movement = false
		inventory.item_picked = null
		picked = false


func _on_mouse_entered():
	if inventory.item_in_movement:
		inventory.try_change_item_positions(get_index())
