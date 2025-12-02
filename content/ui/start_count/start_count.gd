class_name StartCounter extends Control

@onready var center_label: Label = %CenterLabel
@export var next_delay := 0.5
var sequence : PackedStringArray = ["3", "2", "1", "CONQUER !"]

signal sequence_finished

func _ready() -> void:
	self.hide()

func start_count():
	self.show()
	for i in sequence.size():
		center_label.text = sequence[i]
		await get_tree().create_timer(next_delay).timeout
	
	self.hide()
	sequence_finished.emit()
