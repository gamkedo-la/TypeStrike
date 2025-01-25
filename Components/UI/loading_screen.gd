extends Control


func _ready():
	if OS.has_feature('web'):
		LootLocker.lootlocker_ready.connect(_go_to_main_menu)
		LootLocker.initialize()
	else:
		SteamInit.steam_ready.connect(_go_to_main_menu)
		SteamInit.initialize_steam()

func _go_to_main_menu():
	get_tree().change_scene_to_file("res://Components/UI/MainMenu.tscn")
