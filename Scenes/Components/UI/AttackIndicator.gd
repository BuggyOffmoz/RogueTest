extends Control
class_name AttackIndicator

signal AttackFinished

@export var point_margin : float = 128.0
@export var indicator_mov_time : float = 2.0
#@export_enum('LINEAL', 'BOUNCE') var trans : int = 0

@onready var point = $Point
@onready var indicator = $Indicator
@onready var indicator_area = $Indicator/Area2D

var tween : Tween

func _ready() -> void:
	randomize()
	#start_attack()

func start_attack() -> void:
	visible = true
	set_random_point()
	var final_pos = get_rect().size.x - indicator.get_rect().size.x
	tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(indicator, 'position:x', final_pos, indicator_mov_time).set_delay(0.5)
	tween.tween_callback(attack_finished)
	
func attack_finished() -> void:
	attack_stopped()
	AttackFinished.emit()
	
func attack_stopped():
	if tween:
		tween.kill()
	indicator.position.x = 0.0
	visible = false
	
func get_defend_action() -> bool:
	if indicator_area.get_overlapping_areas() != []:
		return true
	else:
		return false
	
func set_random_point() -> void:
	var pos_x = get_rect().size.x
	var random_pos = randf_range(0.0 + point_margin, pos_x - point_margin)
	point.position.x = random_pos
	
#func _input(event): ## DEBUG
#	if Input.is_action_just_pressed("debug_button"):
#		start_attack()
