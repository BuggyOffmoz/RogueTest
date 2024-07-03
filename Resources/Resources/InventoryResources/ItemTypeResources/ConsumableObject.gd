@tool

extends Resource

class_name ConsumableObject


@export_subgroup(" Base configurations")
@export var item_type : AllItemInfo.consumable_item_type:
	set(value):
		item_type = value
		notify_property_list_changed()

# CONSUMABLE CONFIGURATIONS
@export_range(0,100,1) var life_recovery := 0
@export_range(0,100,1) var shield_recovery := 0
#@export_range(0,100,1) var item_condition := 100

@export_subgroup("Item specs")
# FOOD CONFIGURATIONS
@export_range(0,100,1) var hunger_value := 0

# POTIONS CONFIGURATIONS
@export_range(0,100,1) var enchanted_value = 0


func _validate_property(property: Dictionary) -> void:
	pass
	#if property.name in ["hunger_value"]:
		#if item_type == AllItemInfo.consumable_item_type.FOOD:
			#property.usage = PROPERTY_USAGE_EDITOR
		#else:
			#property.usage = PROPERTY_USAGE_NO_EDITOR
	#
	#if property.name in ["enchanted_value"]:
		#if item_type == AllItemInfo.consumable_item_type.POTIONS:
			#property.usage = PROPERTY_USAGE_EDITOR
		#else:
			#property.usage = PROPERTY_USAGE_NO_EDITOR

