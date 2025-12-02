class_name BaseMap extends Node2D

@onready var planets_container: Node2D = %PlanetsContainer
var base_planets : Array[BaseCell] = []
var game_planets : Array[BaseCell] = []

func _ready() -> void:
	for planet in planets_container.get_children():
		if planet is BaseCell:
			base_planets.append(planet)

func start_game():
	game_planets = base_planets.duplicate(true)

func on_planet_captured(planet: BaseCell):
	if get_hostile_planet().size() == 0:
		Game.game_finished.emit(Enums.Team.ALLY)
	elif get_player_planets().size() == 0:
		Game.game_finished.emit(Enums.Team.HOSTILE)

func reset_map():
	pass

#region Utils
func get_player_planets() -> Array[BaseCell]:
	return game_planets.filter(sort_player)

func get_hostile_planet() -> Array[BaseCell]:
	return game_planets.filter(sort_hostile)
	
func get_neutral_planets() -> Array[BaseCell]:
	return game_planets.filter(sort_neutral)
	
func sort_player(planet: BaseCell):
	return planet.team == Enums.Team.ALLY
	
func sort_hostile(planet: BaseCell):
	return planet.team == Enums.Team.HOSTILE
	
func sort_neutral(planet: BaseCell):
	return planet.team == Enums.Team.NEUTRAL
#endregion
