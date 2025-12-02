class_name BaseAI extends Node2D

enum ActionState {PLAN, WAIT, REST}

var attack_timer := Timer.new()
var playing := false

func _connect_signals():
	Game.ai_attack_launched.connect(react_to_ai_attack)
	Game.player_attack_launched.connect(react_to_player_attack)
	Game.planet_captured.connect(react_to_planet_captured)
	Game.game_started.connect(start_playing)
	Game.game_finished.connect(stop_playing.unbind(1))
	attack_timer.timeout.connect(pick_target)

func _ready() -> void:
	_connect_signals()
	add_child(attack_timer)
	

func start_playing():
	playing = true
	attack_timer.start(5)
	
func stop_playing():
	playing = false
	attack_timer.stop()

func pick_target():
	pass
	
func react_to_player_attack(data: AttackData):
	pass
	
func react_to_ai_attack(ai: BaseAI, data: AttackData):
	pass

func react_to_planet_captured(cell: BaseCell):
	pass


func launch_attack(from_cell: BaseCell, to_cell: BaseCell):
	var attack_data = from_cell.get_attack_data(to_cell)
	from_cell.launch_ships(attack_data)
	Game.ai_attack_launched.emit(self, attack_data)


## Utils
func sort_player(cell: BaseCell):
	return cell.team == Enums.Team.ALLY
	
func sort_hostile(cell: BaseCell):
	return cell.team == Enums.Team.HOSTILE
	
func sort_neutral(cell: BaseCell):
	return cell.team == Enums.Team.NEUTRAL

func get_player_planets() -> Array[BaseCell]:
	var planets = Game.current_game_scene.cell_list
	return planets.filter(sort_player)

func get_hostile_planet() -> Array[BaseCell]:
	var planets = Game.current_game_scene.cell_list
	return planets.filter(sort_hostile)
	
func get_neutral_planets() -> Array[BaseCell]:
	var planets = Game.current_game_scene.cell_list
	return planets.filter(sort_neutral)

func sort_unit_count(planet_a: BaseCell, planet_b: BaseCell, ascending: bool = false):
	if ascending:
		return planet_a.unit_count < planet_b.unit_count
	else:
		return planet_a.unit_count > planet_b.unit_count
