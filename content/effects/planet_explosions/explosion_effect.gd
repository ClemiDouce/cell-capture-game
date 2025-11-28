class_name PlanetExplosion extends Node2D

@export_range(0.1, 1, 0.1) var min_scale : float
@export_range(0.2, 1.5, 0.1) var max_scale : float

func _ready() -> void:
	assert(min_scale < max_scale, "Z'etes con en fait ?")
	var random_scale = randf_range(min_scale, max_scale)
	scale = Vector2(random_scale, random_scale)
