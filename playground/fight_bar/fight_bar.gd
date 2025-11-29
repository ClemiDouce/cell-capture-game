class_name FightBar extends Control

@onready var left_bar: ColorRect = %LeftBar
@onready var right_bar: ColorRect = %RightBar
@onready var right_label: Label = %RightLabel
@onready var left_label: Label = %LeftLabel
@export var damage_curve: Curve
signal fight_started
signal fight_finished(winner)

var hostile_count = 0
var player_count = 0
var fighting := false

var resolution_delay : float = 0.1
var resolution_time : float = 0.

func _input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and fighting == false:
		player_count = randi_range(10, 100)
		hostile_count = randi_range(10, 100)
	
	elif Input.is_action_just_pressed("ui_left"):
		player_count += 5
	elif Input.is_action_just_pressed("ui_right"):
		hostile_count += 5

func resolve_fight(delta: float):
	var total : float = player_count + hostile_count
	var player_ratio = player_count / total
	var hostile_ratio = hostile_count / total
	var player_damage = floori(damage_curve.sample(player_ratio))
	var hostile_damage = floori(damage_curve.sample(hostile_ratio))
	player_count -= hostile_damage
	hostile_count -= player_damage
	if player_count <= 0:
		player_count = 0
		fight_finished.emit("hostile")
		fighting = false
	elif hostile_count <= 0:
		hostile_count = 0
		fight_finished.emit("player")
		fighting = false
		
func _process(delta: float) -> void:
	if fighting == false:
		if player_count > 0 and hostile_count > 0:
			fighting = true
			resolution_time = 0.
			fight_started.emit()
	else:
		print("-- Fight processing --")
		resolution_time += delta
		if resolution_time >= resolution_delay:
			resolution_time -= resolution_delay
			resolve_fight(delta)
	update_fight_bar()
			

func update_fight_bar():
	right_label.visible = hostile_count != 0
	left_label.visible = player_count != 0
	var total : float = player_count + hostile_count
	var player_ratio = player_count / total
	var hostile_ratio = hostile_count / total
	left_bar.size_flags_stretch_ratio = player_ratio
	right_bar.size_flags_stretch_ratio = hostile_ratio
	right_label.text = str(hostile_count)
	left_label.text = str(player_count)
