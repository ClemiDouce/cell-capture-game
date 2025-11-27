@tool
class_name SineComponent extends Node

@export var target: Node2D

@export var frequency := 1.
@export var amplitude := 1.
var time := 0.

var launched := false
var base_value : float = 0

func launch():
	randomize()
	time = randf_range(0, 100)
	base_value = target.position.y
	launched = true

func _physics_process(delta: float) -> void:
	if launched:
		time += delta
		
		if target:
			target.position.y = base_value + get_sine()
		
func get_sine():
	return sin(time * frequency) * amplitude
