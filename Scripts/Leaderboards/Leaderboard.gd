extends HTTPRequest
class_name Leaderboard

signal api_ready
signal upload_score_completed
signal leaderboard_entries_retrieved(data: Dictionary)

func initialize():
	pass

func upload_score(board_name: String, score: int):
	print('are we calling this one?')
	pass

func get_leaderboard_entries(board_name: String):
	pass
