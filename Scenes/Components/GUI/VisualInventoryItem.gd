extends Control

class_name VisualInventoryItem


var picked := false

# nodes
var inventory : ContainerSlotSystem

@onready var item_icon = $ItemIcon as TextureRect
@onready var visual_item_amount = $ItemAmount as Label

var image_in_moving : Sprite2D

var item_amount := 0

var internal_item : InventoryItem

func _ready():
	actualize_inventory_item()

func _process(delta):
	if image_in_moving and inventory.item_picked == self:
		image_in_moving.global_position = get_global_mouse_position() + Vector2(20,20)

func actualize_inventory_item():
	if internal_item and visual_item_amount:
		item_icon.texture = internal_item.item_icon
		if item_amount > 1:
			visual_item_amount.set_deferred("text",str(item_amount))
			visual_item_amount.visible = true
		
		else:
			visual_item_amount.visible = false
		
		if item_amount <= 0:
			inventory.try_erase_item(internal_item,1,self)

func create_image_move_item():
	var new_image = Sprite2D.new()
	new_image.texture = item_icon.texture
	image_in_moving = new_image
	image_in_moving.z_index = 100
	image_in_moving.z_as_relative = false
	image_in_moving.scale = Vector2(0.3,0.3)
	get_tree().get_nodes_in_group("node_for_icons")[0].add_child(new_image)
func erase_image_move_item():
	image_in_moving.queue_free()
	image_in_moving = null

func _on_gui_input(event:InputEvent):
	if event.is_action_pressed("item_open_options") and not picked:
		if inventory.action_manager != null:
			if get_tree().get_nodes_in_group("OptionPupOp") != null:
				var option_popup = get_tree().get_nodes_in_group("OptionPupOp")[0] as ItemOptionsPopUp
				option_popup.item_selection = self
				option_popup.container = inventory
				option_popup.show_popup()
			#inventory.action_manager.equipe_item(internal_item)

	if event.is_action_pressed("item_normal_action") and not picked:
		inventory.item_in_movement = true
		inventory.item_picked = self
		picked = true
		create_image_move_item()
	elif event.is_action_released("item_normal_action") and picked:
		inventory.item_in_movement = false
		inventory.item_picked = null
		picked = false
		erase_image_move_item()

func _on_mouse_entered():
	if inventory.item_in_movement:
		inventory.try_change_item_positions(get_index())
