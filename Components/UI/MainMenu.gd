extends Control


func _ready():
	if OS.get_name() == "Web":
		$"VBoxContainer/QuitButton".visible = false
