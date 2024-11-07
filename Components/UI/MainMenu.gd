extends Control


func _ready():
	var x = -1 if 1 < 0 else 1
	if OS.get_name() == "Web":
		$"VBoxContainer/QuitButton".visible = false
