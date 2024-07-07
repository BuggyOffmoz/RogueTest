extends Node
class_name CombatSystem

@export var GUI : CanvasLayer
@export var energy_bar : ProgressBar
@export var health_bar : ProgressBar
@export var player_controller : PlayerController
@export var attack_indicator : DefendIndicator
@export var defend_indicator : DefendIndicator

@onready var defend_timer : Timer = $DefendTime

var enemies_in_scene : Array[EnemyBase] = []

var energy_tween : Tween
var health : float = 100.0 : set = set_health, get = get_health
var max_health : float = 100.0

## Player Attack ##
var on_player_attack : bool = false

## Playeree Defense ##
var player_on_defend : bool = false
var player_on_indicator : bool = false
var current_enemy : EnemyBase = null
var player_shield_amount : float = 0.0

func _ready():
	GameState.connect('StartCombat', start_combat)
	GameState.connect('EnemyDefeated', enemy_defeated)
	GameState.connect('EnemyOnAttack', enemy_start_attack)
	defend_indicator.connect('EnemyAttackFinished', enemy_attack)
	attack_indicator.connect('EnemyAttackFinished', player_attack_finished)
	energy_bar.value = energy_bar.max_value
	health = player_controller.player_stats.base_health
	max_health = health
	health_bar.max_value = health
	
func start_combat(_enemies_data : Array[EnemyData]) -> void:
	GUI.start_combat(_enemies_data)
	enemies_in_scene.clear()
	enemies_in_scene = GUI.get_enemies()
	
func reset_tween(time: float) -> void:
	energy_bar.value = 0.0
	if energy_tween:
		energy_tween.kill()
	energy_tween = create_tween()
	energy_tween.tween_property(energy_bar, 'value', 100.0, time)
	
	
## Player Turn ##
func player_on_attack_state():
	GameState.combat_state = GameState.ATTACK
	on_player_attack = true
	attack_indicator.start_attack()
	
func player_attack(_item : InventoryItem) -> void:
	if on_player_attack and attack_indicator.get_defend_action():
		var damage = _item.e_item_type.base_damage
		if energy_bar.value < energy_bar.max_value:
			damage = damage / 5
		reset_tween(_item.e_item_type.energy_time)
		GUI.enemy_screen.get_node("EnemyBase").on_hurt(damage)
	else:
		GUI.message_label.text += '\nPlayer Miss Attack!'
	
func player_attack_finished():
	on_player_attack = false
	GameState.combat_state = GameState.IDLE
	
func player_defend(_item : InventoryItem):
	if player_on_indicator:
		player_shield_amount = _item.e_item_type.shield_amount
		if defend_indicator.get_defend_action():
			player_on_defend = true
			defend_indicator.attack_finished()
		else:
			player_on_defend = false
			defend_indicator.attack_finished()
	else:
		return
	
	
## Enemy Turn ##
func enemy_start_attack(enemy : EnemyBase):
	player_on_indicator = true
	player_on_defend = false
	current_enemy = enemy
	defend_indicator.start_attack()
	
func enemy_attack() -> void:
	player_on_indicator = false
	var damage = current_enemy.enemy_data.attack_damage
	if player_on_defend:
		var reduced_damage = (player_shield_amount / 100) * damage
		damage = damage - int(reduced_damage)
		GUI.message_label.text += '\nAttack Defended! / Reduced Damage: ' + str(reduced_damage)
		GUI.message_label.text += '\nEnemy damage: ' + str(damage)
	else:
		GUI.message_label.text += '\nFailed Defense! / Enemy damage: ' + str(damage)
	health -= damage
	
	GameState.ai_controller.ai_attack_finished(current_enemy)
	
func enemy_defeated(enemy : EnemyBase) -> void:
	enemies_in_scene.erase(enemy)
	if enemies_in_scene == []:
		combat_finished()
		defend_indicator.attack_stopped()
		player_on_defend = false
	
func combat_finished() -> void:
	GameState.combat_finished()
	GUI.message_label.text += '\nCombat Finished'
	
func player_item_consume(item : VisualInventoryItem):
	health += item.internal_item.c_item_type.life_recovery

func set_health(value):
	if value <= 0:
		health = 0
		GameState.player_dead()
	else:
		health = value
		
	if value > max_health:
		value = max_health 
		
	health_bar.value = value
	
func get_health():
	return health



