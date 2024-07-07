extends ColorRect
class_name IndicatorPoint

@onready var area : Area2D = $Area2D

func set_active():
	area.monitorable = true
	area.monitoring = true
	
func set_inactive():
	area.monitorable = false
	area.monitoring = false
