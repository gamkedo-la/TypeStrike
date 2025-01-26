extends Node

signal steam_ready

const STEAM_APP_ID = 3490830
var leaderboard_handle: int

var active := false

func _process(delta):
	if active:
		Steam.run_callbacks()
	
func initialize_steam() -> bool:
	OS.set_environment("SteamAppId", str(STEAM_APP_ID))
	OS.set_environment("SteamGameId", str(STEAM_APP_ID))
	active = true
	var init_response : Dictionary = Steam.steamInitEx()
	if init_response.status == 0:
		Steam.leaderboard_find_result.connect(_on_leaderboard_find_result)
		Steam.findOrCreateLeaderboard("typestrike_leader", Steam.LEADERBOARD_SORT_METHOD_DESCENDING, Steam.LEADERBOARD_DISPLAY_TYPE_NUMERIC)
	else:
		printerr("Steam failed to initialize")
		print_debug(init_response)
		active = false
	return active

func _on_leaderboard_find_result(handle: int, found: int) -> void:
	leaderboard_handle = handle
	steam_ready.emit()
