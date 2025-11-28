class_name BaseAI extends Node2D

enum ActionState {PLAN, WAIT, REST}

var attack_timer := Timer.new()

func _ready() -> void:
	add_child(attack_timer)
	attack_timer.timeout.connect(choose_random_target)
	attack_timer.start(5)
	
func choose_random_target():
	var hostile_cells = Game.current_game_scene.cell_list.filter(sort_hostile)
	var ally_cells = Game.current_game_scene.cell_list.filter(sort_ally)
	
	
	var target = hostile_cells.pick_random()
	var ally = ally_cells.pick_random()
	launch_attack(ally, target)
	attack_timer.start(5)

func launch_attack(from_cell: BaseCell, to_cell: BaseCell):
	var attack_data = from_cell.get_attack_data(to_cell)
	from_cell.launch_ships(attack_data)
	Game.ai_attack_launched.emit(self, attack_data)

func sort_hostile(cell: BaseCell):
	return cell.team != Enums.Team.HOSTILE
	
func sort_ally(cell: BaseCell):
	return cell.team == Enums.Team.HOSTILE
