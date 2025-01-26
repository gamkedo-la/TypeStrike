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
	LootLocker.initialize() # delete later after adding leaderboard wrapper
	LootLocker.leaderboard_list_retrieved.connect(fill_table)
	LootLocker.get_leaderboards('typestrike-level-2')

func on_level_completed():
	if visible:
		return
	visible = true
	var time_sum = PlayerState.wpm.reduce(func(sum, number): return sum + number)
	var wpm_score = wpm(PlayerState.letters_typed, time_sum)
	wpm_value.text = "%d" % wpm_score
	errors_value.text = "%d" % PlayerState.mistakes
	score_value.text = "%d" % PlayerState.score

func wpm(letters, time) -> float:
	return (letters / 5.0) / millis_to_minutes(time)

func millis_to_minutes(millis: float) -> float:
	return millis / (1000.0 * 60.0)

func fill_table(data: Dictionary):
	print("Player short id %s" % LootLocker.player_short_id)
	for entry in data.items:
		var row : TableRow = row_scene.instantiate()
		row.set_data(entry.player.name, 0)
		row.set_data(str(entry.score), 1)
		row.set_data(str(entry.rank), 2)
		row.set_highlight(true)
		if str(entry.player.id) == str(LootLocker.player_short_id):
			row.set_highlight(true)
		tree.add_child(row)
	loading_message.visible = false
