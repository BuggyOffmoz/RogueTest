@tool
extends Resource

class_name InventoryItem


@export_subgroup("Base Configuration")

## Esto se usara para definir tanto el nombre en el inventario visual ya que podemos usar el sistema de traduccion.
@export var item_id := "N/A"

@export var item_icon : Texture2D

## Si podra ser estackeado en el inventario
@export var stackeable := false

## Siplemente define si es equipable como Arma/Escudo
@export var equippable := false:
	set(value):
		equippable = value
		notify_property_list_changed()

## Define si se puede consumir (Esto deslosara opciones para saber que estados se aplican)
@export var consumable := false:
	set(value):
		consumable = value
		notify_property_list_changed()

## Define si se puede poner en los accesos directos
@export var accessible := false:
	set(value):
		accessible = value
		notify_property_list_changed()


@export_subgroup("Equippable config")

@export var e_item_type : EquipableObject

@export_subgroup("Consumable config")

@export var c_item_type : ConsumableObject

func _validate_property(_property: Dictionary) -> void:
	pass
	#if property.name in ["e_item_type"]:
		#if equippable:
			#property.usage = PROPERTY_USAGE_EDITOR
		#else:
			#property.usage = PROPERTY_USAGE_NO_EDITOR
	#if property.name in ["c_item_type"]:
		#if consumable:
			#property.usage = PROPERTY_USAGE_EDITOR
		#else:
			#property.usage = PROPERTY_USAGE_NO_EDITOR


