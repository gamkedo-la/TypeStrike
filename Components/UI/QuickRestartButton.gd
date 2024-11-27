extends IMenuButton

@export var level_scene : String
@export var unpause: bool = false
@export var menu_index := 0

func _pressed():
	if unpause:
		get_tree().paused = false
	if level_scene:
		get_tree().change_scene_to_file(level_scene)
