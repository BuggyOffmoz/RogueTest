extends Control
class_name DefendIndicator

signal EnemyAttackFinished

const POINT = preload("res://Scenes/Components/Combat/IndicatorPoint.tscn")

@export_category("Setup")
@export var point_margin : float = 128.0
@export var indicator_mov_time : float = 2.0
@export var delay_sec : float = 0.5
@export var label_text : String

@export_category('Points')
@export var points_quantity : int = 1
var points_in_scene : Array[IndicatorPoint] = []
#@export_enum('LINEAL', 'BOUNCE') var trans : int = 0

@onready var indicator = $Indicator
@onready var indicator_area = $Indicator/Area2D

var tween : Tween

func _ready() -> void:
	randomize()
	$Label.text = label_text
	for n in points_quantity:
		var point = POINT.instantiate()
		$Points.add_child(point)
		points_in_scene.append(point)
	

func start_attack() -> void:
	visible = true
	for i in points_in_scene:
		set_random_point(i)
	var final_pos = get_rect().size.x - indicator.get_rect().size.x
	tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(indicator, 'position:x', final_pos, indicator_mov_time).set_delay(delay_sec)
	tween.tween_callback(attack_finished)
	
func attack_finished() -> void:
	attack_stopped()
	EnemyAttackFinished.emit()
	
func attack_stopped():
	if tween:
		tween.kill()
	indicator.position.x = 0.0
	visible = false
	for i in points_in_scene:
		i.set_active()
		
func attack_paused(value : bool):
	if tween:
		if value:
			tween.pause()
		else:
			tween.play()
		
	
func get_defend_action() -> bool:
	if indicator_area.get_overlapping_areas() != []:
		var areas : Array[Area2D] = indicator_area.get_overlapping_areas()
		for i in areas:
			i.monitorable = false
			i.monitoring = false
		return true
	else:
		return false
	
func set_random_point(_point : IndicatorPoint) -> void:
	var pos_x = get_rect().size.x
	var random_pos = randf_range(0.0 + point_margin, pos_x - point_margin)
	_point.position.x = random_pos
	
#func _input(event): ## DEBUG
#	if Input.is_action_just_pressed("debug_button"):
#		start_attack()
