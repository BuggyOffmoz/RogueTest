extends Node
class_name AIController

var enemies_ready_to_attack : Array[EnemyBase] = []

func _ready():
	GameState.ai_controller = self

func ai_attack_request(enemy : EnemyBase):
	#if enemies_ready_to_attack.size() >= 1:
	#	return
	if !enemies_ready_to_attack.has(enemy):
		enemies_ready_to_attack.append(enemy)
		
func ai_attack_finished(enemy : EnemyBase):
	if enemies_ready_to_attack.has(enemy):
		enemies_ready_to_attack.erase(enemy)
		GameState.combat_state = GameState.IDLE
		enemy.start_attack_timer()
		
func ai_on_attack_signal():
	if GameState.game_state == GameState.COMBAT:
		if GameState.combat_state == GameState.IDLE:
			enemies_ready_to_attack[0].attack()
			GameState.combat_state = GameState.DEFEND
			
func remove_enemy(enemy : EnemyBase):
	if enemies_ready_to_attack.has(enemy):
		enemies_ready_to_attack.erase(enemy)

func _process(_delta):
	if enemies_ready_to_attack.size() != 0:
		ai_on_attack_signal()
