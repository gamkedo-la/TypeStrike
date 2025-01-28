extends Leaderboard
class_name SteamLeaderboards

signal leaderboard_handle_found
var leaderboard_handle: int

func initialize():
	Steam.leaderboard_score_uploaded.connect(_on_leaderboard_score_uploaded)
	Steam.leaderboard_scores_downloaded.connect(_on_leaderboard_scores_downloaded)
	if SteamInit.active:
		api_ready.emit()
	else:
		SteamInit.steam_ready.connect(func(): 
			api_ready.emit())
		SteamInit.initialize_steam()

func upload_score(board_name: String, score: int):
	_get_leaderboard_handle(board_name)
	await leaderboard_handle_found
	Steam.uploadLeaderboardScore(score, true, [], leaderboard_handle)

func get_leaderboard_entries(board_name: String):
	_get_leaderboard_handle(board_name)
	await leaderboard_handle_found
	Steam.downloadLeaderboardEntries(1, 10, Steam.LEADERBOARD_DATA_REQUEST_GLOBAL_AROUND_USER, leaderboard_handle)

func _get_leaderboard_handle(board_name: String):
	Steam.leaderboard_find_result.connect(_on_leaderboard_find_result)
	Steam.findOrCreateLeaderboard(board_name, Steam.LEADERBOARD_SORT_METHOD_DESCENDING, Steam.LEADERBOARD_DISPLAY_TYPE_NUMERIC)

func _on_leaderboard_find_result(handle: int, found: int) -> void:
	if found == 1:
		leaderboard_handle = handle
		leaderboard_handle_found.emit()

func _on_leaderboard_scores_downloaded(message: String, leaderboard_handle: int, leaderboard_entries: Array):
	print(message)
	print(leaderboard_entries)
	leaderboard_entries_retrieved.emit({'items': leaderboard_entries})

func _on_leaderboard_score_uploaded(success: int, this_handle: int, this_score: Dictionary) -> void:
	print(this_score)
	upload_score_completed.emit()
