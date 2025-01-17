extends Control

@onready var wpm_value = %wpm_value
@onready var errors_value = %errors_Value
@onready var score_value = %score_value
@onready var tree = %tree

const row_scene = preload("res://Components/UI/table_row.tscn")

func _ready():
	visible = false
	fill_table()

func on_level_completed():
	if visible:
		return
	visible = true
	var num_words = PlayerState.wpm.size()
	var time_sum = PlayerState.wpm.reduce(func(sum, number): return sum + number)
	var wpm_score = wpm(PlayerState.letters_typed, time_sum)
	wpm_value.text = "%d" % wpm_score
	errors_value.text = "%d" % PlayerState.mistakes
	score_value.text = "%d" % PlayerState.score

func wpm(letters, time) -> float:
	return (letters / 5.0) / millis_to_minutes(time)

func millis_to_minutes(millis: float) -> float:
	return millis / (1000.0 * 60.0)

func fill_table():
	var score : Array[int] = []
	for i in 10:
		score.append(randi_range(1, 99999))
	score.sort()
	score.reverse()
	
	for i in 10:
		var row : TableRow = row_scene.instantiate()
		if i == 3:
			row.set_highlight(true)
		row.set_data('Tyfoo', 0)
		row.set_data("%d" % score[i], 1)
		row.set_data(str(i+1), 2)
		tree.add_child(row)
	
