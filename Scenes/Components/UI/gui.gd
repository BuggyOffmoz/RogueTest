extends CanvasLayer

## Main Screen ##
@onready var message_label : Label = $MainContainer/HBoxContainer/CenterScreen/Message/Label

func _ready():
	GameState.connect("ChangeState", state_changed)
	
func state_changed(state : int):
	match state:
		GameState.MOVE:
			message_label.text = "..."
		GameState.COMBAT:
			message_label.text = "In Battle"
