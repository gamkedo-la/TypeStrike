extends TextureButton
class_name LevelListItem

@export var level_data: LevelData

func _ready():
	$ColorRect/Label.text = level_data.level_name
	pressed.connect(func():
		get_tree().change_scene_to_file(level_data.level_path))
