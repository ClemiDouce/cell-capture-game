class_name AggressivAI extends BaseAI

func pick_target():
	var player_planets = Game.current_game_scene.map.get_player_planets()
	player_planets.sort_custom(sort_unit_count.bind(true))
	var self_planets = Game.current_game_scene.map.get_hostile_planet()
	self_planets.sort_custom(sort_unit_count)
	if player_planets.is_empty() or self_planets.is_empty():
		return
	var ok_planets = self_planets.filter(func(cell: BaseCell): return cell.unit_count > 30)
	
	if player_planets[0].unit_count < 30 and !ok_planets.is_empty():
		launch_attack(ok_planets[0], player_planets[0])
	elif not Game.current_game_scene.map.get_neutral_planets().is_empty():
		launch_attack(self_planets[0], Game.current_game_scene.map.get_neutral_planets().pick_random())
	else:
		launch_attack(self_planets[0], player_planets[0])
	
	attack_timer.start(5)

func react_to_player_attack(data: AttackData):
	pass
	#var ally_planets = get_hostile_planet()
	#ally_planets.sort_custom(sort_unit_count)
	#var from_planet = ally_planets.pop_front()
	#launch_attack(from_planet, data.start_cell)
