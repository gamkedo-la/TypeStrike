extends Button

@export var level_scene : String

func _pressed():
	get_tree().change_scene_to_file(level_scene)
