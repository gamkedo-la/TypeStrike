extends Control
@onready var wpm_value = $VBoxContainer/HBoxContainer/wpm_value
@onready var errors_value = $VBoxContainer/HBoxContainer2/errors_value

func _ready():
	visible = false

func on_level_completed():
	if visible:
		return
	visible = true
	var num_words = PlayerState.wpm.size()
	var time_sum = PlayerState.wpm.reduce(func(sum, number): return sum + number)
	var wpm_score = wpm(PlayerState.letters_typed, time_sum)
	wpm_value.text = "%d" % wpm_score
	errors_value.text = "%d" % PlayerState.mistakes

func wpm(letters, time) -> float:
	return (letters / 5.0) / millis_to_minutes(time)

func millis_to_minutes(millis: float) -> float:
	return millis / (1000.0 * 60.0)
