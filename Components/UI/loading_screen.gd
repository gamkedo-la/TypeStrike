extends Control


func _ready():
	if OS.has_feature('web'):
		init_lootlocker()
	else:
		if not init_steam():
			init_lootlocker()

func init_lootlocker():
	LootLocker.lootlocker_ready.connect(_go_to_main_menu)
	LootLocker.initialize()

func init_steam():
	SteamInit.steam_ready.connect(_go_to_main_menu)
	return SteamInit.initialize_steam()

func _go_to_main_menu():
	get_tree().change_scene_to_file("res://Components/UI/MainMenu.tscn")
