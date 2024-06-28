@tool

extends Resource

class_name EquipableObject

@export_subgroup(" Base configurations")
@export var item_type : AllItemInfo.equippable_item_type:
	set(value):
		item_type = value
		notify_property_list_changed()

# EQUIPPABLE CONFIGURATIONS
@export var item_weight : AllItemInfo.equippable_weight

@export_range(0,100,1) var item_condition := 100

@export_subgroup("Item specs")
# SWORD CONFIGURATIONS
@export_range(0,100,1) var base_damage := 0
@export_range(0,100,1) var base_critical_chance := 0:
	set(value):
		base_critical_chance = value
		notify_property_list_changed()

@export var critical_damage := Vector2(0,0)

# SHIELD CONFIGURATIONS
@export_range(0,100,1) var shield_amount = 0


func _validate_property(property: Dictionary) -> void:
	if property.name in ["base_damage","base_critical_chance"]:
		if item_type == AllItemInfo.equippable_item_type.SWORD:
			property.usage = PROPERTY_USAGE_EDITOR
		else:
			property.usage = PROPERTY_USAGE_NO_EDITOR
	
	if property.name in ["shield_amount"]:
		if item_type == AllItemInfo.equippable_item_type.SHIELD:
			property.usage = PROPERTY_USAGE_EDITOR
		else:
			property.usage = PROPERTY_USAGE_NO_EDITOR
	
	if property.name in ["critical_damage"]:
		if base_critical_chance != 0 and item_type == AllItemInfo.equippable_item_type.SWORD:
			property.usage = PROPERTY_USAGE_EDITOR
		else:
			property.usage = PROPERTY_USAGE_NO_EDITOR
