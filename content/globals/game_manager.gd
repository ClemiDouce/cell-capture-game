extends Node

signal ai_attack_launched(ai: BaseAI, data: AttackData)
signal player_attack_launched(data: AttackData)

signal planet_captured(cell: BaseCell)

signal game_started
signal game_finished(winner : Enums.Team)

var current_game_scene : GameScreen
