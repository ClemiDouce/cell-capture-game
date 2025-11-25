extends Node2D

var selected_ally_cell : Array[BaseCell]
var last_target : BaseCell
var temp_cell : BaseCell

var point_param : PhysicsPointQueryParameters2D

func _ready() -> void:
	point_param = PhysicsPointQueryParameters2D.new()
	point_param.collide_with_areas = true
	point_param.collide_with_bodies = false
	point_param.collision_mask = 4

func _process(_delta: float) -> void:
	queue_redraw()

func _physics_process(_delta: float) -> void:
	var space_state = get_world_2d().direct_space_state
	point_param.position = get_global_mouse_position()
	var collision = space_state.intersect_point(point_param, 6)
	if collision:
		if Input.is_action_just_released("left_click"):
			var attack = last_target != null
			var attack_value := 0
			for cell: BaseCell in selected_ally_cell:
				if attack:
					attack_value += cell.pop_half_unit()
				cell.selected = false
			selected_ally_cell.clear()
			if attack:
				last_target.apply_attack(Enums.Team.ALLY, attack_value)
				last_target.selected = false
				last_target = null
		if Input.is_action_pressed("left_click"):
			var first = collision[0]["collider"] as BaseCell
			if selected_ally_cell.is_empty():
				first.selected = true
				selected_ally_cell.append(first)
			else:
				pass
			
			# Old
			#if first.team == Enums.Team.ALLY:
				#if first not in selected_ally_cell:
					#first.selected = true
					#selected_ally_cell.append(first)
			#else:
				#if !selected_ally_cell.is_empty():
					#last_target = first
					#last_target.selected = true
		else:
			pass
	else:
		if last_target:
			last_target.selected = false
			last_target = null

func _draw() -> void:
	if !selected_ally_cell.is_empty():
		for cell: BaseCell in selected_ally_cell:
			draw_line(cell.global_position, get_global_mouse_position(), Color.WHITE_SMOKE, 2)
