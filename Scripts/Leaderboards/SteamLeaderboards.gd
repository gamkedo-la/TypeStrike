extends Leaderboard
class_name SteamLeaderboards

signal leaderboard_handle_found
var leaderboard_handle: int
const STEAM_APP_ID = 3490830
var steam_api: Object = null

func _ready():
	initialize()

func _process(float) -> void:
	if Engine.has_singleton('Steam') and steam_api != null:
		steam_api.run_callbacks()

func initialize():
	if Engine.has_singleton('Steam'):
		steam_api = Engine.get_singleton('Steam')
		OS.set_environment("SteamAppId", str(STEAM_APP_ID))
		OS.set_environment("SteamGameId", str(STEAM_APP_ID))
		
		steam_api.leaderboard_score_uploaded.connect(_on_leaderboard_score_uploaded)
		steam_api.leaderboard_scores_downloaded.connect(_on_leaderboard_scores_downloaded)
		steam_api.steamInitEx()
		api_ready.emit()

func upload_score(board_name: String, score: int):
	_get_leaderboard_handle(board_name)
	await leaderboard_handle_found
	steam_api.uploadLeaderboardScore(score, true, [], leaderboard_handle)

func parse_entry(entry: Dictionary) -> Dictionary:
	return {
		'name': steam_api.getFriendPersonaName(entry.steam_id),
		'score': str(entry.score),
		'rank': str(entry.global_rank),
		'highlight': steam_api.getSteamID() == entry.steam_id
	}

func get_leaderboard_entries(board_name: String):
	_get_leaderboard_handle(board_name)
	await leaderboard_handle_found
	steam_api.downloadLeaderboardEntries(1, 10, steam_api.LEADERBOARD_DATA_REQUEST_GLOBAL_AROUND_USER, leaderboard_handle)

func _get_leaderboard_handle(board_name: String):
	steam_api.leaderboard_find_result.connect(_on_leaderboard_find_result)
	steam_api.findOrCreateLeaderboard(board_name, steam_api.LEADERBOARD_SORT_METHOD_DESCENDING, steam_api.LEADERBOARD_DISPLAY_TYPE_NUMERIC)

func _on_leaderboard_find_result(handle: int, found: int) -> void:
	if found == 1:
		leaderboard_handle = handle
		leaderboard_handle_found.emit()

func _on_leaderboard_scores_downloaded(message: String, leaderboard_handle: int, leaderboard_entries: Array):
	leaderboard_entries_retrieved.emit({'items': leaderboard_entries})

func _on_leaderboard_score_uploaded(success: int, this_handle: int, this_score: Dictionary) -> void:
	upload_score_completed.emit()
