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

@export_subgroup("Weapons Item specs")
# SWORD CONFIGURATIONS
@export_range(0,100,1) var base_damage := 0.0
@export_range(0,100,1) var base_critical_chance := 0
@export var energy_time : float = 0.5


@export var critical_damage := Vector2(0,0)

@export_subgroup("Equippable Item specs")
# SHIELD CONFIGURATIONS
@export_range(0,100,1) var shield_amount = 0
@export var shield_time : float = 0.3
@export var shield_cooldown : float = 1.0


func _validate_property(property: Dictionary) -> void:
	pass
	#if property.name in ["base_damage","base_critical_chance"]:
		#if item_type == AllItemInfo.equippable_item_type.WEAPON:
			#property.usage = PROPERTY_USAGE_EDITOR
		#else:
			#property.usage = PROPERTY_USAGE_NO_EDITOR
	#
	#if property.name in ["shield_amount"]:
		#if item_type == AllItemInfo.equippable_item_type.DEFEND:
			#property.usage = PROPERTY_USAGE_EDITOR
		#else:
			#property.usage = PROPERTY_USAGE_NO_EDITOR
	#
	#if property.name in ["critical_damage"]:
		#if base_critical_chance != 0 and item_type == AllItemInfo.equippable_item_type.WEAPON:
			#property.usage = PROPERTY_USAGE_EDITOR
		#else:
			#property.usage = PROPERTY_USAGE_NO_EDITOR
