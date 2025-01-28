extends Control

@onready var loading_message = %loading_message
@onready var wpm_value = %wpm_value
@onready var errors_value = %errors_Value
@onready var score_value = %score_value
@onready var tree = %tree
@onready var retry_button = %retry_button

const row_scene = preload("res://Components/UI/table_row.tscn")

func _ready():
	visible = false
	retry_button.pressed.connect(func():
		get_tree().reload_current_scene())

func on_level_completed():
	if visible:
		return
	visible = true
	
	# Collect stats
	var time_sum = PlayerState.wpm.reduce(func(sum, number): return sum + number)
	var wpm_score = wpm(PlayerState.letters_typed, time_sum)
	var scene_name = 'typestrike_' + get_tree().current_scene.name
	
	# Submit new score to leaderboard
	LeaderboardManager.board_api.leaderboard_entries_retrieved.connect(fill_table)
	LeaderboardManager.board_api.upload_score_completed.connect(func():
		LeaderboardManager.get_leaderboard_entries(scene_name))
	LeaderboardManager.upload_score(scene_name, PlayerState.score)
	
	# Set local data
	wpm_value.text = "%d" % wpm_score
	errors_value.text = "%d" % PlayerState.mistakes
	score_value.text = "%d" % PlayerState.score

func wpm(letters, time) -> float:
	return (letters / 5.0) / millis_to_minutes(time)

func millis_to_minutes(millis: float) -> float:
	return millis / (1000.0 * 60.0)

func _submit_new_score():
	pass

func fill_table(data: Dictionary):
	for entry : Dictionary in data.items:
		var row : TableRow = row_scene.instantiate()
		var lb_entry : Dictionary = LeaderboardManager.board_api.parse_entry(entry)
		row.set_data(lb_entry.name, 0)
		row.set_data(lb_entry.score, 1)
		row.set_data(lb_entry.rank, 2)
		row.set_highlight(lb_entry.highlight)
		tree.add_child(row)
	loading_message.visible = false
