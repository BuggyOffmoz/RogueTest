extends CanvasLayer

const ENEMY = preload("res://Scenes/Entities/Enemies/enemy_base.tscn")

## Main Screen ##
@onready var enemy_screen : Panel = %Panel
@onready var message_label : RichTextLabel = %GameDes
@onready var container_manger = %ContainerManger as ContainerManager
@onready var game_over_screen = %GameOverScreen


func _ready():
	GameState.connect("ChangeState", state_changed)
	GameState.connect("StartCombat", start_combat)
	GameState.connect("PlayerDead", game_over)
	
func start_combat(enemies : Array[EnemyData]):
	create_enemy(enemies)
	
func create_enemy(enemies : Array[EnemyData]):
	var enemy = ENEMY.instantiate()
	enemy.enemy_data = enemies[0] ### Solo por ahora es un solo enemigo
	enemy_screen.add_child(enemy)
	
func state_changed(state : int):
	match state:
		GameState.MOVE:
			message_label.text += "\n "
		GameState.COMBAT:
			message_label.text += "\nCombat Started!"

func game_over():
	game_over_screen.visible = true

func _on_inventory_pressed():
	container_manger.show_container()
	change_to_inventory_state()

func change_to_inventory_state():
	if container_manger.visible:
		GameState.previous_state = GameState.game_state
		GameState.change_state(GameState.INVENTORY)
		get_tree().paused = true
	else:
		GameState.change_state(GameState.previous_state)
		get_tree().paused = false
