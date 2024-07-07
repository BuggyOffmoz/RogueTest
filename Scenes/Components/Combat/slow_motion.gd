extends Timer

var slowmo_active: bool = false

var normal_time_scale : float = 1.0
@export var slowmo_time_scale : float = 0.5
@export var slowmo_enter_time: float = 0.5
@export var slowmo_quit_time: float = 0.25
#@export var slow_in_time := false

var tween : Tween

var count = 0.0

func _ready():
	set_process(false)

func enter_slowmo_animation():
	#if tween:
	#	tween.kill()
	#tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	#tween.tween_property(Engine, "time_scale", slowmo_time_scale, slowmo_enter_time)
	#tween.tween_callback(start_slowmo)
	Engine.time_scale = slowmo_time_scale

func exit_slowmo_animation():
	#if tween:
	#	tween.kill()
	#tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	#tween.tween_property(Engine, "time_scale", normal_time_scale, slowmo_quit_time)
	#tween.tween_callback(end_slowmo)
	Engine.time_scale = normal_time_scale

func start_slowmo():
	Engine.time_scale = slowmo_time_scale
	slowmo_active = true

func end_slowmo():
	Engine.time_scale = normal_time_scale
	slowmo_active = false

func request_slowmo_change(_time_scale := 0.05, time_in := 0.0, time_out := 0.0, slowmo_toggle_mode := false, active:= true):
	slowmo_time_scale = _time_scale
	slowmo_enter_time = time_in
	slowmo_quit_time = time_out
	if !slowmo_toggle_mode:
		enter_slowmo_animation()
		count = 0.0
		set_process(true)
	else:
		if active:
			enter_slowmo_animation()
		else:
			exit_slowmo_animation()
			
func _process(delta):
	count += delta
	if count >= 0.005:
		set_process(false)
		exit_slowmo_animation()

func _on_timeout():
	exit_slowmo_animation()
