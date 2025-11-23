class_name BaseCell extends Area2D

@onready var unit_count_label: Label = %UnitCountLabel
@export var sprite: Sprite2D

@export_category("Team")
@export var team : Enums.Team = Enums.Team.NEUTRAL

@export_category("Generation")
@export var unit_generation := 1
@export var generation_delay := 0.3
var generation_time := 0.

var unit_count := 0:
	set = set_unit_count


func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	generate_unit(delta)
	

func generate_unit(delta: float):
	generation_time += delta
	if generation_time >= generation_delay:
		generation_time -= generation_delay
		unit_count += unit_generation




# Setter / Getter
func set_unit_count(new_value: int):
	unit_count = new_value
	unit_count_label.text = str(unit_count)

func set_team(new_team: Enums.Team):
	team = new_team
	var new_color: Color
	match(team):
		Enums.Team.ALLY:
			new_color = Color.GREEN
		Enums.Team.HOSTILE:
			new_color = Color.RED
		Enums.Team.NEUTRAL:
			new_color = Color.WHITE
	sprite.self_modulate = new_color
