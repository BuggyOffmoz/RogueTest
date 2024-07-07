extends Node

class_name ActionsManager

### Nodes
@export var GUI : CanvasLayer
@export var base_container : ContainerSlotSystem
@export var actions_buttons : Array[Button]
@export var combat_system : CombatSystem

@export_category("Inventory")
@export var container_manger : ContainerManager
@export var visual_container : VisualContainerManager
#@export var main_inventory: ContainerSlotSystem

@export_category("Action manager config")

### Nodos especificados
@export var visual_attack_slot : Control
@export var visual_defend_slot : Control

@export var visual_first_item : Control
@export var visual_second_item : Control

var actions_management_items = {
	"default_item" : null,
	"attack_item" : null,
	"defend_item" : null,
	"first_item" : null,
	"second_item" : null,
}


func _ready():
	actions_management_items.default_item = ItemPreloader.get_item('HANDS')
	base_configurations()


func base_configurations():
	
	base_container.action_manager = self
	### esto es para ahorrar conectar señales a funciones :D
	for button in actions_buttons:
		button.pressed.connect(button_action.bind(button.name))
	

func equipe_item(_item:InventoryItem):
	
	
	if _item.equippable:
		if _item.e_item_type.item_type == AllItemInfo.equippable_item_type.WEAPON:
			actions_management_items["attack_item"] = _item
			visual_attack_slot.get_node("ItemIcon").texture = _item.item_icon
		else:
			actions_management_items["defend_item"] = _item
			visual_defend_slot.get_node("ItemIcon").texture = _item.item_icon
			
	

func attack_item():
	if GameState.game_state == GameState.COMBAT and \
	GameState.combat_state != GameState.DEFEND:
		if GameState.combat_state == GameState.IDLE:
			combat_system.player_on_attack_state()
			return
		
		#print(actions_management_items["attack_item"] != null)
		if actions_management_items["attack_item"] != null:
			var _item : InventoryItem = actions_management_items["attack_item"]
			combat_system.player_attack(_item)
		else:
			var _item : InventoryItem = actions_management_items['default_item']
			combat_system.player_attack(_item)
	else:
		return

func defend_item():
	if GameState.game_state == GameState.COMBAT:
		if actions_management_items["defend_item"] != null:
			var _item : InventoryItem = actions_management_items["defend_item"]
			combat_system.player_defend(_item)
		else:
			#GUI.message_label.text += '\nNo Shield Equipped!'
			var _item : InventoryItem = actions_management_items['default_item']
			combat_system.player_defend(_item)
	else:
		return

func first_item():
	pass

func second_item():
	pass

func consume_item():
	pass

func consume_particular_item(_item:VisualInventoryItem):
	
	if _item.internal_item.c_item_type.item_type == AllItemInfo.consumable_item_type.FOOD:
		_item.item_amount -= 1
		_item.actualize_inventory_item()
	
	#GUI.enemy_screen.get_node("EnemyBase").on_hurt(_item.e_item_type.base_damage)
		combat_system.player_item_consume(_item)
	#print('Item Consume')
		
		
		
### INVENTORY ###
func _on_inventory_pressed():
	container_manger.show_container()
	if container_manger.visible:
		visual_container.insert_container_in_center_gui_panel()
	else:
		container_manger.clear_containers()
	change_to_inventory_state()

func change_to_inventory_state():
	if container_manger.visible:
		GameState.previous_state = GameState.game_state
		GameState.change_state(GameState.INVENTORY)
		get_tree().paused = true
	else:
		GameState.change_state(GameState.previous_state)
		get_tree().paused = false

## INVENTORY ##
#func _input(event):
	#if event.is_action_released("item_normal_action"):
		#pass
		#main_inventory.verify_other_containers_items_movements()

### Señales

func button_action(_button_name:StringName):
	if has_method(_button_name.to_lower()+"_item"):
		call(_button_name.to_lower()+"_item")



