extends Node

signal api_ready

var board_api : Leaderboard

func _ready():
	if OS.has_feature('web'):
		board_api = LootLocker.new()
		print('create lootlocker object')
	else:
		board_api = SteamLeaderboards.new()

func initialize():
	add_child(board_api)
	board_api.api_ready.connect(_emit_api_ready)
	board_api.initialize()

func get_leaderboard_entries(board_name: String):
	board_api.get_leaderboard_entries(board_name)

func upload_score(board_name: String, score: int):
	board_api.upload_score(board_name, score)

func _emit_api_ready():
	api_ready.emit()
