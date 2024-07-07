extends VBoxContainer

class_name ItemOptionsPopUp

@export var equippable_options : Array[Button]
@export var consumable_options : Array[Button]


var in_shop := false
var in_forge := false

var item_selection : VisualInventoryItem
var container : ContainerSlotSystem

func _input(event):
	if event.is_action_pressed("item_normal_action") and visible and verify_input():
		visible = false
	
func _process(_delta):
	if visible:
		verify_item_existence()

func show_popup():
	visible = true
	position = get_global_mouse_position()
	re_show_options()


func re_show_options():
	if item_selection.internal_item.equippable:
		for option in equippable_options:
			option.visible = true
	else:
		for option in equippable_options:
			option.visible = false
	
	if item_selection.internal_item.consumable:
		for option in consumable_options:
			option.visible = true
	else:
		for option in consumable_options:
			option.visible = false

func verify_item_existence():
	if not is_instance_valid(item_selection):
		visible = false
		item_selection = null
		container = null

func verify_input():
	for button:Button in get_children():
		if button.is_hovered():
			return(false)
	
	print("AAAAAAAA")
	return(true)
	

#=======================================SEÑALES
func _on_equip_pressed():
	if container.action_manager != null:
		var action_manager = container.action_manager
		action_manager.equipe_item(item_selection.internal_item)

func _on_consume_pressed():
	if container.action_manager != null:
		var action_manager = container.action_manager
		action_manager.consume_particular_item(item_selection)


func _on_trash_pressed():
	container.try_erase_item(item_selection.internal_item,item_selection.item_amount,item_selection)



