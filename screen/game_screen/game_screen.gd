class_name GameScreen extends Node2D

@onready var cell_container: Node2D = %CellContainer
@onready var start_count: StartCounter = %StartCount
@onready var end_text_box: VBoxContainer = %EndTextBox
@onready var start_game_container: VBoxContainer = %StartGameContainer

var state := Game.GameState.MAIN
var cell_list : Array[BaseCell]

func _ready() -> void:
	Game.current_game_scene = self
	Game.game_finished.connect(on_game_finished)

func start_game():
	state = Game.GameState.GAME
	start_count.start_count()
	await start_count.sequence_finished
	Game.game_started.emit()

func on_game_finished(winner: Enums.Team):
	match(winner):
		Enums.Team.ALLY:
			pass
		Enums.Team.HOSTILE:
			pass

func on_player_win():
	pass
	
func on_player_loose():
	pass

func _input(event: InputEvent) -> void:
	if state == Game.GameState.MAIN:
		if event is InputEventKey and event.pressed:
			start_game()
