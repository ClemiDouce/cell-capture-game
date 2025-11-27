class_name AttackData extends RefCounted

var start_position : Vector2
var end_position: Vector2
var target : BaseCell
var attack_count : int

func _init(_start: Vector2, _end: Vector2, _target: BaseCell, _attack_count: int):
	start_position = _start
	end_position = _end
	target = _target
	attack_count = _attack_count
