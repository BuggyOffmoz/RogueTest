extends CanvasLayer

const ENEMY = preload("res://Scenes/Entities/Enemies/enemy_base.tscn")

## Main Screen ##
@onready var enemy_screen : Control = %Panel
@onready var message_label : RichTextLabel = %GameDes
@onready var container_manger = %ContainerManger as ContainerManager
@onready var game_over_screen = %GameOverScreen

@onready var item_icon : Label = %Item_icon


func _ready():
	GameState.connect("ChangeState", state_changed)
	GameState.connect("PlayerDead", game_over)
	
func start_combat(enemies : Array[EnemyData]):
	create_enemy(enemies)
	
func get_enemies() -> Array[EnemyBase]:
	var enemies : Array[EnemyBase] = []
	for i in enemy_screen.get_children():
		if i is EnemyBase:
			enemies.append(i)
	return enemies
	
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
