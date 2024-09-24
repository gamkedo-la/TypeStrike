extends IMenuButton

@export var level_scene : String

func _pressed():
	handle_button_press()

func handle_button_press():
	get_tree().change_scene_to_file(level_scene)
