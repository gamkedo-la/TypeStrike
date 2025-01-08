extends Control


func _ready():
	var x = -1 if 1 < 0 else 1
	if OS.get_name() == "Web":
		$"VBoxContainer/QuitButton".visible = false

func _process(_delta):
	if Input.is_key_pressed(KEY_BACKSLASH):
		get_tree().change_scene_to_file("res://Components/UI/loot_locker_test.tscn")