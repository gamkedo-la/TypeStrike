extends Control


func _ready():
	if not LeaderboardManager.is_node_ready():
		await LeaderboardManager.ready
	LeaderboardManager.api_ready.connect(_go_to_main_menu)
	LeaderboardManager.initialize()

func _go_to_main_menu():
	get_tree().change_scene_to_file("res://Components/UI/MainMenu.tscn")
