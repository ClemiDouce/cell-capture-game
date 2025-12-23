class_name GameScreen extends BaseMap

@onready var start_count: StartCounter = %StartCount
@onready var start_game_container: VBoxContainer = %StartGameContainer
@onready var player_win_box: VBoxContainer = %PlayerWinBox
@onready var player_loose_box: VBoxContainer = %PlayerLooseBox

var state := Game.GameState.MAIN

func _ready() -> void:
	Game.current_game_scene = self
	Game.game_finished.connect(on_game_finished)
	start_game_container.show()

func start_game():
	player_loose_box.hide()
	player_win_box.hide()
	start_game_container.hide()
	state = Game.GameState.GAME
	map.reset_map()
	start_count.start_count()
	await start_count.sequence_finished
	Game.game_started.emit()

func on_game_finished(winner: Enums.Team):
	state = Game.GameState.END
	match(winner):
		Enums.Team.ALLY:
			player_win_box.show()
		Enums.Team.HOSTILE:
			player_loose_box.show()

func _input(event: InputEvent) -> void:
	if state == Game.GameState.MAIN or state == Game.GameState.END:
		if event is InputEventKey and event.pressed:
			start_game()
