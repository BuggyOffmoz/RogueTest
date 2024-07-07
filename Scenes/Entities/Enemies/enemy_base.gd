extends Control
class_name EnemyBase

#signal EnemyDead(enemy)

@export var enemy_data : EnemyData = null
var health : float = 0.0 : set = _set_health, get = _get_health

@onready var sprite : TextureRect = $Sprite
@onready var health_bar : ProgressBar = $ProgressBar
@onready var attack_timer : ProgressBar = $Attack
#@onready var attack_timer : Timer = $AttakTimer

func _ready():
	health_bar.max_value = enemy_data.health
	health = enemy_data.health
	health_bar.value = enemy_data.health
	sprite.texture = enemy_data.screen_texture
	
	randomize()
	start_attack_timer()
	#var value = randf_range(enemy_data.attack_time_range.x, enemy_data.attack_time_range.y)
	#attack_timer.set_wait_time(value)
	#attack_timer.start()
	
func on_hurt(damage : float):  ## En un futuro debería ser una clase  que guarde varios datos como:
	var curr_health = health   ## Damage, Tipo de daño, knockback? etc.
	curr_health -= damage
	if curr_health <= 0:
		curr_health = 0
		## Enemy Dead State
		#EnemyDead.emit(self)
		GameState.enemy_defeated(self)
		GameState.ai_controller.remove_enemy(self)
		queue_free()					 	## Solo por ahora queue_free
	else:
		## Enemy Hurt State
		pass
	_set_health(curr_health)
	
func _set_health(value : float):
	health = value
	health_bar.value = health
	
func _get_health() -> float:
	return health

func start_attack_timer():
	#print('enemy_base.gd: ' + "Enemy Start Attack")
	attack_timer.value = 0.0
	var time_value = randf_range(enemy_data.attack_time_range.x, enemy_data.attack_time_range.y)
	var tween = create_tween()
	tween.tween_property(attack_timer, 'value', 100, time_value)
	tween.tween_callback(request_attack)
	
func request_attack():
	GameState.ai_controller.ai_attack_request(self)
	
func attack():
	GameState.enemy_attack(self)
