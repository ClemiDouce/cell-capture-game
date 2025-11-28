class_name GameScreen extends Node2D

@onready var cell_container: Node2D = %CellContainer

var cell_list : Array[BaseCell]

func _ready() -> void:
	Game.current_game_scene = self
	for cell in cell_container.get_children():
		if cell is BaseCell:
			cell_list.append(cell)
