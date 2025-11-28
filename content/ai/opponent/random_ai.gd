class_name RandomAI extends BaseAI

func pick_target():
	var hostile_cells = get_ally_planets()
	var ally_cells = Game.current_game_scene.cell_list.filter(sort_ally)
	
	
	var target = hostile_cells.pick_random()
	var ally = ally_cells.pick_random()
	launch_attack(ally, target)
	attack_timer.start(5)

func react_to_player_attack(data: AttackData):
	pass
	
func reaction_to_ai_attack(ai: BaseAI, data: AttackData):
	pass

func reaction_to_captured_planet():
	pass
