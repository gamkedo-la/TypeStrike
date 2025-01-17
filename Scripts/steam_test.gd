extends Control

@onready var submit_score_button = $"Submit Score Button"
@onready var leaderboard_entries = $"VBoxContainer/leaderboard entries"
@onready var tree = $Tree

func _ready():
	submit_score_button.pressed.connect(submit_leaderboard_score)
	Steam.leaderboard_scores_downloaded.connect(update_leaderboard_scores)
	Steam.leaderboard_score_uploaded.connect(on_leaderboard_score_uploaded)
	SteamInit.steam_ready.connect(refresh_entries)
	var root = tree.create_item()
	var l1 = tree.create_item(root)
	var l2 = tree.create_item(root)
	tree.set_column_title(0, "This Play")
	tree.set_column_title(1, "Your Best")
	tree.set_column_title(2, "Leaderboard")
	l1.set_text(0, '12345')
	l1.set_text(1, '12345')
	l1.set_text(2, '12345')
	l2.set_text(0, '543201')
	l2.set_text(1, '345623')
	l2.set_text(2, '9834')

func refresh_entries():
	Steam.downloadLeaderboardEntries(1, 10, Steam.LEADERBOARD_DATA_REQUEST_GLOBAL, SteamInit.leaderboard_handle)

func on_leaderboard_score_uploaded(success, handle, score):
	if success:
		refresh_entries()
	else:
		printerr("failed uploading score")

func submit_leaderboard_score():
	var score = randi_range(0, 99999)
	var name = Steam.getPersonaName()
	Steam.uploadLeaderboardScore(score, true, PackedInt32Array(), SteamInit.leaderboard_handle)

func update_leaderboard_scores(message: String, this_leaderboard_handle: int, results: Array) -> void:
	tree.clear()
	var root = tree.create_item()
	for result in results:
		var row = tree.create_item(root)
		row.set_text(0, get_user_nickname(result.steam_id))
		row.set_text(1, str(result.score))
		row.set_text(2, str(result.global_rank))
	#for child in leaderboard_entries.get_children():
		#child.queue_free()
	#for result in results:
		#var row := data_row(result)
		#leaderboard_entries.add_child(row)
		
func data_row(entry) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_child(data_cell(get_user_nickname(entry.steam_id)))
	row.add_child(data_cell(entry.score))
	row.add_child(data_cell(entry.global_rank))
	return row

func get_user_nickname(steam_id: int) -> String:
	var name = Steam.getFriendPersonaName(steam_id)
	return name if name else str(steam_id)

func data_cell(data) -> Label:
	var cell := Label.new()
	cell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cell.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cell.text = str(data)
	return cell
