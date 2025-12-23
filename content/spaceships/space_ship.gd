class_name SpaceShip extends Node2D

@export var ally_texture: Texture2D
@export var hostile_texture: Texture2D

@onready var sine_component: SineComponent = $SineComponent
@onready var ship_texture: Sprite2D = %ShipTexture
@onready var detection_area: Area2D = $Area2D

var attack_data: AttackData
var launched := false

var speed: float = 120.
var damage : int = 1
var spawn_offset : float = 30.
var attack_offset : Vector2

func spawn_ship(data: AttackData):
	ship_texture.texture = ally_texture if data.team == Enums.Team.ALLY else hostile_texture
	var direction = data.start_position.direction_to(data.end_position)
	self.global_rotation = direction.angle()
	attack_data = data
	speed *= attack_data.speed_modifier
	damage = attack_data.damage
	attack_offset = Vector2(
		randf_range(-spawn_offset, spawn_offset),
		randf_range(-spawn_offset, spawn_offset)
	)
	var spawn_tween = create_tween().set_parallel()
	spawn_tween.tween_property(self, "global_position", data.start_position + attack_offset, 1)
	spawn_tween.tween_property(self, "scale", Vector2.ONE, 1)
	spawn_tween.tween_callback(launch_ship).set_delay(0.5)
	sine_component.launch()
	
func launch_ship():
	launched = true
	
func _process(delta: float) -> void:
	if launched:
		self.global_position = self.global_position.move_toward(attack_data.target.global_position, delta * speed)
		self.look_at(attack_data.target.global_position)

func land_ship(target_planet: BaseCell):
	var offset = Vector2(
		randf_range(-spawn_offset, spawn_offset),
		randf_range(-spawn_offset, spawn_offset)
	)
	var land_tween = create_tween().set_parallel()
	land_tween.tween_property(self, "global_position", target_planet.global_position + offset, 1)
	land_tween.tween_property(self, "scale", Vector2.ZERO, 1)
	await land_tween.finished
	target_planet.apply_attack(attack_data.team, damage)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if !launched:
		return
	if area is BaseCell:
		if area == self.attack_data.target:
			launched = false
			land_ship(area)
		elif area.cell_type.type_name == "defense" and area.team != attack_data.team:
			launched = false
			land_ship(area)
