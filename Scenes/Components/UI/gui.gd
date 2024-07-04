extends CanvasLayer

const ENEMY = preload("res://Scenes/Entities/Enemies/enemy_base.tscn")

## Main Screen ##
@onready var enemy_screen : Panel = %Panel
@onready var message_label : Label = $MainContainer/HBoxContainer/CenterScreen/Message/Label
@onready var container_manger = %ContainerManger as ContainerManager


func _ready():
	
	GameState.connect("ChangeState", state_changed)
	GameState.connect("StartCombat", start_combat)
	
func start_combat(enemies : Array[EnemyData]):
	create_enemy(enemies)
func create_enemy(enemies : Array[EnemyData]):
	var enemy = ENEMY.instantiate()
	enemy.enemy_data = enemies[0] ### Solo por ahora es un solo enemigo
	enemy_screen.add_child(enemy)
	
func state_changed(state : int):
	match state:
		GameState.MOVE:
			message_label.text = "..."
		GameState.COMBAT:
			message_label.text = "In Battle"





func _on_inventory_pressed():
	container_manger.show_container()
