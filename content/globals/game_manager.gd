extends Node

signal ai_attack_launched(ai: BaseAI, data: AttackData)
signal player_attack_launched(data: AttackData)

signal planet_conquered(cell: BaseCell)

var current_game_scene : GameScreen
