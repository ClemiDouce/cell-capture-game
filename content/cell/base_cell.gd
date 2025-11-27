@tool
class_name BaseCell extends Area2D

@onready var unit_count_label: Label = %UnitCountLabel
@onready var cell_sprite: Sprite2D = %CellSprite

const SPACE_SHIP = preload("uid://bphm3wyo54ao7")
const EXPLOSION_EFFECT = preload("uid://bvxeobvnj5c3f")


@export var initial_unit_count := 0
@export_category("Team")
@export var team : Enums.Team = Enums.Team.NEUTRAL

@export_category("Generation")
@export var unit_generation := 1
@export var generation_delay := 0.3
@export var max_unit := 50
@export var cell_type : CellType
var generation_time := 0.
var current_attack : AttackData

var selected := false:
	set = set_selected

var unit_count := 0:
	set = set_unit_count

var team_frame : Dictionary = {
	Enums.Team.ALLY: [0, 6],
	Enums.Team.HOSTILE: [2,5],
	Enums.Team.NEUTRAL: [4]
}

func _ready() -> void:
	set_team_color()
	unit_count = initial_unit_count
	
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
		damage_count += 1
		if damage_count % explosion_limit == 0:
			spawn_explosion()
		
		unit_count -= value
		if unit_count < 0:
			unit_count = abs(unit_count)
			set_team(_team)

func launch_ships_to(target: BaseCell, pourcent: float = 50.):
	var direction = self.global_position.direction_to(target.global_position)
	var radius_offset = 90
	var attack_value = get_pourcent_of_unit(pourcent)
	var attack_data = AttackData.new(
		self.global_position + (direction * radius_offset),
		target.global_position - (direction * radius_offset),
		target,
		attack_value
	)
	for i in attack_value:
		var attack_ship = create_ship()
		attack_ship.spawn_ship(attack_data)
		await get_tree().create_timer(0.1).timeout
	current_attack = attack_data
	return attack_data

# Setter / Getter
func set_unit_count(new_value: int):
	unit_count = new_value
	unit_count_label.text = str(unit_count)

func set_team(new_team: Enums.Team):
	team = new_team
	set_team_color()
	

func set_team_color():
	cell_sprite.frame = team_frame[team].pick_random()

func set_selected(value: bool):
	selected = value
	queue_redraw()
	
func _draw() -> void:
	if selected:
		draw_circle(Vector2.ZERO, 80, Color.FLORAL_WHITE, false, 5)
	
	#if current_attack:
		#draw_line(Vector2.ZERO, current_attack.end_position - self.position, Color.DARK_RED, 5)
		#draw_circle(current_attack.target.global_position - self.global_position, 90, Color.DARK_RED, false, 5)

func get_pourcent_of_unit(pourcent: float):
	var value = floor(unit_count * (pourcent/100))
	unit_count -= value
	return value

func create_ship() -> SpaceShip:
	var ship = SPACE_SHIP.instantiate() as SpaceShip
	get_tree().current_scene.add_child(ship)
	ship.global_position = self.global_position
	return ship
	
var damage_count := 0
var explosion_limit := 3

func spawn_explosion():
	var explosion_effect = EXPLOSION_EFFECT.instantiate() as PlanetExplosion
	var random_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	add_child(explosion_effect)
	explosion_effect.position = random_direction * randf_range(30., 60.)
	explosion_effect.rotation = random_direction.angle()
