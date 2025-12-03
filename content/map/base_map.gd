class_name BaseMap extends Node2D

@onready var planets_container: Node2D = %PlanetsContainer
var planets : Array[BaseCell] = []
var game_planets : Array[BaseCell] = []
var planets_reset_data : Dictionary = {}

func _ready() -> void:
	Game.planet_captured.connect(on_planet_captured)
	for planet in planets_container.get_children():
		if planet is BaseCell:
			planets.append(planet)
			planets_reset_data[planet] = {
				"team": planet.team,
				"unit": planet.initial_unit_count
			}

func reset_map():
	for planet in game_planets:
		planet.unit_count = planets_reset_data[planet]["unit"]
		planet.team = planets_reset_data[planet]["team"]

func on_planet_captured(planet: BaseCell):
	if get_hostile_planet().size() == 0:
		Game.game_finished.emit(Enums.Team.ALLY)
	elif get_player_planets().size() == 0:
		Game.game_finished.emit(Enums.Team.HOSTILE)

#region Utils
func get_player_planets() -> Array[BaseCell]:
	return planets.filter(sort_player)

func get_hostile_planet() -> Array[BaseCell]:
	return planets.filter(sort_hostile)
	
func get_neutral_planets() -> Array[BaseCell]:
	return planets.filter(sort_neutral)
	
func sort_player(planet: BaseCell):
	return planet.team == Enums.Team.ALLY
	
func sort_hostile(planet: BaseCell):
	return planet.team == Enums.Team.HOSTILE
	
func sort_neutral(planet: BaseCell):
	return planet.team == Enums.Team.NEUTRAL
#endregion
