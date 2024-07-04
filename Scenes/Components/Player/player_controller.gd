extends Node
class_name PlayerController

@export var GUI : CanvasLayer
@export var player_stats : PlayerStats

func _ready():
	player_stats = PlayerStats.new() ## Este player  stats  deberia  crearse en algun  creador de personaje o algo similar.
	


func _on_button_pressed():
	GameState.restart_game()
