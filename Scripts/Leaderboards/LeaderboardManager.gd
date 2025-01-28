extends Node

signal api_ready

var board_api : Leaderboard
	
func use_steam():
	board_api = SteamLeaderboards.new()
	board_api.api_ready.connect(_emit_api_ready)
	board_api.initialize()

func use_lootlocker():
	board_api = LootLocker.new()
	board_api.api_ready.connect(_emit_api_ready)
	board_api.initialize()

func get_leaderboard_entries(board_name: String):
	print('getting leaderboard entries')
	board_api.get_leaderboard_entries(board_name)

func upload_score(board_name: String, score: int):
	print('uploading score')
	board_api.upload_score(board_name, score)

func _emit_api_ready():
	api_ready.emit()
