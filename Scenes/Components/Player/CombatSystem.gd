extends Node
class_name CombatSystem

@export var GUI : CanvasLayer
@export var energy_bar : ProgressBar
@export var health_bar : ProgressBar
@export var defend_bar : TextureProgressBar
@export var player_controller : PlayerController

@onready var defend_timer : Timer = $DefendTime

var enemies_in_scene : Array[EnemyData] = []

var energy_tween : Tween
var health : float = 100.0 : set = set_health, get = get_health

## Playeree Defense ##
var player_on_defend : bool = false
var player_shield_amount : float = 0.0

func _ready():
	GameState.connect('StartCombat', start_combat)
	GameState.connect('EnemyDefeated', enemy_defeated)
	GameState.connect('EnemyOnAttack', enemy_attack)
	energy_bar.value = energy_bar.max_value
	health = player_controller.player_stats.base_health
	health_bar.max_value = health
	
func start_combat(_enemies : Array[EnemyData]) -> void:
	enemies_in_scene.clear()
	enemies_in_scene = _enemies
	
func reset_tween(time: float) -> void:
	energy_bar.value = 0.0
	if energy_tween:
		energy_tween.kill()
	energy_tween = create_tween()
	energy_tween.tween_property(energy_bar, 'value', 100.0, time)
	
func player_attack(_item : InventoryItem) -> void:
	var damage = _item.e_item_type.base_damage
	if energy_bar.value < energy_bar.max_value:
		damage = damage / 4
	reset_tween(_item.e_item_type.energy_time)
	GUI.enemy_screen.get_node("EnemyBase").on_hurt(damage)
	#GUI.message_label.text += '\nPlayer Damage: ' + str(damage)
	
func player_defend(_item : InventoryItem):
	if player_on_defend:
		return
	player_on_defend = true
	defend_bar.value = 0.0
	var tween = create_tween()
	tween.tween_property(defend_bar, 'value', 100.0, _item.e_item_type.shield_time)
	tween.tween_callback(_on_defend_time_timeout)
	#defend_timer.set_wait_time(_item.e_item_type.shield_time)
	#defend_timer.start()
	player_shield_amount = _item.e_item_type.shield_amount
	
func _on_defend_time_timeout():
	player_on_defend = false
	defend_bar.value = 100.0
	
func enemy_attack(damage : int) -> void:
	if player_on_defend:
		var reduced_damage = (player_shield_amount / 100) * damage
		damage = damage - int(reduced_damage)
		GUI.message_label.text += '\nReduced Damage: ' + str(reduced_damage)
	GUI.message_label.text += '\nEnemy damage: ' + str(damage)
	health -= damage
	
func enemy_defeated(enemy : EnemyData) -> void:
	enemies_in_scene.erase(enemy)
	if enemies_in_scene == []:
		combat_finished()
	
func combat_finished() -> void:
	GameState.combat_finished()
	GUI.message_label.text += '\nCombat Finished'

func set_health(value):
	if value <= 0:
		health = 0
		GameState.player_dead()
	else:
		health = value
		
	health_bar.value = value
	
func get_health():
	return health


