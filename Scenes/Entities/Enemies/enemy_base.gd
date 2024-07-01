extends Control
class_name EnemyBase

signal EnemyDead(enemy)

var enemy_data : EnemyData = null
var health : float = 0.0 : set = _set_health, get = _get_health

@onready var sprite : TextureRect = $Sprite
@onready var health_bar : ProgressBar = $ProgressBar

func _ready():
	health_bar.max_value = enemy_data.health
	health = enemy_data.health
	health_bar.value = enemy_data.health
	sprite.texture = enemy_data.screen_texture
	
func on_hurt(damage : float):  ## En un futuro debería ser una clase  que guarde varios datos como:
	var curr_health = health   ## Damage, Tipo de daño, knockback? etc.
	curr_health -= damage
	if curr_health <= 0:
		curr_health = 0
		## Enemy Dead State
		EnemyDead.emit(self)
	else:
		## Enemy Hurt State
		pass
	_set_health(curr_health)
	
func _set_health(value : float):
	health = value
	health_bar.value = health
	
func _get_health() -> float:
	return health

