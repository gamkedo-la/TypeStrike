extends IMenuButton

@export var level_scene : String
@export var unpause: bool = false

func _pressed():
	handle_button_press()

func handle_button_press():
	if (unpause):
		get_tree().paused = false
	get_tree().change_scene_to_file(level_scene)
