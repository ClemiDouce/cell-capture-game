class_name AttackData extends RefCounted

var team : Enums.Team
var start_position : Vector2
var end_position: Vector2
var start_cell: BaseCell
var target : BaseCell
var attack_count : int
var damage : int
var speed_modifier : float

func _init(_team: Enums.Team, _start: Vector2, _end: Vector2,_start_cell: BaseCell, _target: BaseCell, _attack_count: int, _speed_modifier: float, _damage: int):
	team = _team
	start_position = _start
	end_position = _end
	start_cell = _start_cell
	target = _target
	attack_count = _attack_count
	speed_modifier = _speed_modifier
	damage = _damage
