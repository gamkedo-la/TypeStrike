extends Node

signal steam_ready

const STEAM_APP_ID = 480
var leaderboard_handle: int

func _init():
	return
	OS.set_environment("SteamAppId", str(STEAM_APP_ID))
	OS.set_environment("SteamGameId", str(STEAM_APP_ID))
	initialize_steam()

func _process(delta):
	Steam.run_callbacks()
	
func initialize_steam() -> void:
	var init_response : Dictionary = Steam.steamInitEx()
	if init_response.status == 0:
		Steam.leaderboard_find_result.connect(_on_leaderboard_find_result)
		Steam.findOrCreateLeaderboard("typestrike_leader", Steam.LEADERBOARD_SORT_METHOD_DESCENDING, Steam.LEADERBOARD_DISPLAY_TYPE_NUMERIC)
		var friend_count = Steam.getFriendCount(Steam.FRIEND_FLAG_ALL)
		print("you have %d steam friends" % friend_count)
		for i in friend_count:
			var friend = Steam.getFriendByIndex(i, Steam.FRIEND_FLAG_ALL)
			var nickname = Steam.getFriendPersonaName(friend)
			print("one is named %s (%s)" % [nickname, str(friend)])
	else:
		printerr("Steam failed to initialize")

func _on_leaderboard_find_result(handle: int, found: int) -> void:
	leaderboard_handle = handle
	steam_ready.emit()
