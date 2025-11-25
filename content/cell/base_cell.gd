class_name BaseCell extends Area2D

@onready var unit_count_label: Label = %UnitCountLabel
@onready var cell_sprite: Sprite2D = %CellSprite
@onready var outline: Sprite2D = %Outline


@export_category("Team")
@export var team : Enums.Team = Enums.Team.NEUTRAL

@export_category("Generation")
@export var unit_generation := 1
@export var generation_delay := 0.3
@export var max_unit := 50
@export var cell_type : CellType
var generation_time := 0.

var selected := false:
	set = set_selected

var unit_count := 0:
	set = set_unit_count


func _ready() -> void:
	set_team_color()
	
func _process(delta: float) -> void:	
	if team == Enums.Team.NEUTRAL or unit_count >= max_unit:
		return
	
	generate_unit(delta)


func generate_unit(delta: float):
	generation_time += delta
	if generation_time >= generation_delay:
		generation_time -= generation_delay
		unit_count += unit_generation

func apply_attack(_team: Enums.Team, value: int):
	if _team == team:
		unit_count += value
	else:
		unit_count -= value
		if unit_count < 0:
			unit_count = abs(unit_count)
			set_team(_team)

# Setter / Getter
func set_unit_count(new_value: int):
	unit_count = new_value
	unit_count_label.text = str(unit_count)

func set_team(new_team: Enums.Team):
	team = new_team
	set_team_color()
	

func set_team_color():
	var new_color: Color
	match(team):
		Enums.Team.ALLY:
			new_color = Color.GREEN
		Enums.Team.HOSTILE:
			new_color = Color.RED
		Enums.Team.NEUTRAL:
			new_color = Color.WHITE
	cell_sprite.self_modulate = new_color

func set_selected(value: bool):
	selected = value
	(outline.material as ShaderMaterial).set_shader_parameter("width", 3. if value else 0.)

func pop_half_unit():
	var value = floor(unit_count/2)
	unit_count -= value
	return value
