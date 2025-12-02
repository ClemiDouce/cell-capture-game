class_name GameScreen extends Node2D

@onready var cell_container: Node2D = %CellContainer
@onready var start_count: StartCounter = %StartCount

var cell_list : Array[BaseCell]

func _ready() -> void:
	Game.current_game_scene = self
	Game.planet_captured.connect(on_planet_captured)
	for cell in cell_container.get_children():
		if cell is BaseCell:
			cell_list.append(cell)
	await get_tree().create_timer(2).timeout
	start_game()

func start_game():
	start_count.start_count()
	await start_count.sequence_finished
	Game.game_started.emit()



func on_player_win():
	pass
	
func on_player_loose():
	pass

func on_planet_captured(planet: BaseCell):
	if get_hostile_planet().size() == 0:
		# Player Win
		pass
	elif get_player_planets().size() == 0:
		# Hostile Win
		pass
	
func get_player_planets() -> Array[BaseCell]:
	var planets = Game.current_game_scene.cell_list
	return planets.filter(sort_player)

func get_hostile_planet() -> Array[BaseCell]:
	var planets = Game.current_game_scene.cell_list
	return planets.filter(sort_hostile)
	
func get_neutral_planets() -> Array[BaseCell]:
	var planets = Game.current_game_scene.cell_list
	return planets.filter(sort_neutral)
	
func sort_player(cell: BaseCell):
	return cell.team == Enums.Team.ALLY
	
func sort_hostile(cell: BaseCell):
	return cell.team == Enums.Team.HOSTILE
	
func sort_neutral(cell: BaseCell):
	return cell.team == Enums.Team.NEUTRAL
