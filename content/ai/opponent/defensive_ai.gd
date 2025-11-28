class_name DefensiveAI extends BaseAI



func react_to_player_attack(data: AttackData):
	var unit_count = 0
	for planet in get_ally_planets():
		unit_count += planet.unit_count
		
	if unit_count > 40:
		
