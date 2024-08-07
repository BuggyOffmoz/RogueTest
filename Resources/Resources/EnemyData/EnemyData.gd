extends Resource
class_name EnemyData

@export_category("UI Variables")
@export var enemy_name : String
@export_multiline var enemy_description : String
@export var screen_texture : Texture2D

@export_category("Stats")
@export var health : float = 100.0
@export var attack_damage : float = 20.0

@export_category('Attack Variables')
@export var attack_time_range : Vector2 = Vector2(2.0, 5.0)

@export_category('Items')
@export var items_dropeables : Array[InventoryItem]
