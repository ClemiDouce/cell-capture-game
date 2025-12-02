extends Node2D

var selected_ally_cell : Array[BaseCell]
var last_target : BaseCell
var cell_hovered : BaseCell

var point_param : PhysicsPointQueryParameters2D
var playing := false

func connect_signals():
	Game.game_started.connect(func(): playing = true)
	Game.game_finished.connect(func(): playing = false)

func _ready() -> void:
	connect_signals()
	point_param = PhysicsPointQueryParameters2D.new()
	point_param.collide_with_areas = true
	point_param.collide_with_bodies = false
	point_param.collision_mask = 4

func _process(_delta: float) -> void:
	queue_redraw()

func _physics_process(_delta: float) -> void:
	if not playing:
		return
	var released := false
	var space_state = get_world_2d().direct_space_state
	point_param.position = get_global_mouse_position()
	var collision = space_state.intersect_point(point_param, 6)
	if Input.is_action_just_released("left_click"):
		if last_target:
			for ally : BaseCell in selected_ally_cell:
				var attack_data = ally.get_attack_data(last_target)
				ally.launch_ships(attack_data)
				Game.player_attack_launched.emit(attack_data)
			last_target.selected = false

		
		for ally: BaseCell in selected_ally_cell:
			ally.selected = false
		selected_ally_cell.clear()
		released = true
	
	if !released:
		if Input.is_action_pressed("left_click"):
			if cell_hovered:
				cell_hovered.hovered = false
				cell_hovered = null
			if collision:
				var first = collision[0]["collider"] as BaseCell
				last_target = first
				last_target.selected = true
				if last_target in selected_ally_cell:
					selected_ally_cell.erase(last_target)
			else:
				if last_target:
					if last_target.team == Enums.Team.ALLY:
						selected_ally_cell.append(last_target)
						last_target.selected = true
					else:
						last_target.selected = false
					last_target = null
		else:
			if collision:
				var first = collision[0]["collider"] as BaseCell
				if first.team == Enums.Team.ALLY:
					cell_hovered = first
					cell_hovered.hovered = true
			else:
				if cell_hovered:
					cell_hovered.hovered = false
					cell_hovered = null
	
func _draw() -> void:
	if last_target and !selected_ally_cell.is_empty():
		for cell: BaseCell in selected_ally_cell:
			var angle = cell.global_position.direction_to(last_target.global_position)
			var start_line = cell.global_position + (angle * 80)
			var end_line = last_target.global_position - (angle * 80)
			draw_line(start_line, end_line, Color.WHITE_SMOKE, 5)
