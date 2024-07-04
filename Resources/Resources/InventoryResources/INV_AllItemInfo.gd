@tool
extends Resource

class_name AllItemInfo

enum equippable_item_type {
	WEAPON,
	DEFEND
}

enum consumable_item_type {
	FOOD,
	POTIONS
}

enum equippable_weight {
	LIGHT,
	MODERATE,
	HEAVY
} 

@export var all_items : Array[InventoryItem]