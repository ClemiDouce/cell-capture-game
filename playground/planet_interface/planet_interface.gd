extends Control

var planet_owner : BaseCell

@onready var fight_bar: FightBar = $FightBar
@onready var capture_bar: ProgressBar = %CaptureBar
@onready var capture_bar_fill: StyleBoxFlat = capture_bar.get_theme_stylebox("fill")
@export var capture_curve: Curve

signal team_changed(new_team: Enums.Team)

@export var planet_value : int = 100
var player_capture := 0
var hostile_capture := 0
var temp_capture := 100:
	set(value):
		temp_capture = clamp(value, -planet_value, planet_value)

var team : Enums.Team = Enums.Team.NEUTRAL:
	set = set_team
var capturing_team : Enums.Team = Enums.Team.NEUTRAL

func _ready():
	setup(Enums.Team.NEUTRAL)
	fight_bar.fight_finished.connect(func(_team: String): print("Fight Ended. Winner is " + _team))

func setup(_team: Enums.Team):
	team = _team
	if team == Enums.Team.ALLY:
		temp_capture = planet_value
	elif team == Enums.Team.HOSTILE:
		temp_capture = -planet_value
	else:
		temp_capture = 0
	capture_bar.max_value = planet_value

func get_capturing_team():
	if fight_bar.fighting == false:
		if fight_bar.player_count > 0:
			capturing_team = Enums.Team.ALLY
		elif fight_bar.hostile_count > 0:
			capturing_team = Enums.Team.HOSTILE
		else:
			capturing_team = Enums.Team.NEUTRAL

func _process(delta: float) -> void:
	if fight_bar.fighting == false:
		get_capturing_team()
		var capturing := false
		match(team):
			Enums.Team.NEUTRAL:
				if capturing_team != Enums.Team.NEUTRAL:
					capturing = true
			Enums.Team.ALLY:
				if capturing_team == Enums.Team.HOSTILE:
					capturing = true
			Enums.Team.HOSTILE:
				if capturing_team == Enums.Team.ALLY:
					capturing = true
		
		if !capturing:
			return
		print(str(capturing_team) + " is capturing")
		if capturing_team == Enums.Team.ALLY:
			temp_capture += 2
		elif capturing_team == Enums.Team.HOSTILE:
			temp_capture -= 2
		
		if team == Enums.Team.ALLY and temp_capture < 0:
			team = Enums.Team.NEUTRAL
		elif team == Enums.Team.HOSTILE and temp_capture > 0:
			team = Enums.Team.NEUTRAL
		elif team == Enums.Team.NEUTRAL:
			if temp_capture == planet_value:
				team = Enums.Team.ALLY
			elif temp_capture == -planet_value:
				team = Enums.Team.HOSTILE
			
		
		update_capture_bar()

func update_capture_bar():
	if capturing_team == Enums.Team.NEUTRAL:
		return
	capture_bar_fill.bg_color = Color("bd4044") if temp_capture < 0 else Color("78b8ff")
	capture_bar.value = abs(temp_capture)
	
	#if capturing_team == Enums.Team.ALLY:
		#capture_bar.value = player_capture
	#elif capturing_team == Enums.Team.HOSTILE:
		#capture_bar.value = hostile_capture
	
	
func set_team(value: Enums.Team):
	team = value
	team_changed.emit(value)
	
	
	
