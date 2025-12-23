class_name BaseMap extends Node2D

@export var map: PlanetLayout

func _ready() -> void:
	Game.current_game_scene = self
