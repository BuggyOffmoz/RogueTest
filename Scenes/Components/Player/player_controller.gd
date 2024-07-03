extends Node
class_name PlayerController

@export var GUI : CanvasLayer

func _on_attack_pressed():
	pass
	#if GameState.game_state == GameState.COMBAT:
		#GUI.enemy_screen.get_children()[0].on_hurt(20.0)
	#else:
		#return


func _on_defend_pressed():
	pass
	#if GameState.game_state == GameState.COMBAT:
		#pass
	#else:
		#return
