extends IMenuButton

@export var level_scene : String
@export var unpause: bool = false
@export var menu_index := 0
@export var autofocus := false

func _ready():
	pressed.connect(_pressed)
	if autofocus:
		grab_focus()

func _pressed():
	if unpause:
		get_tree().paused = false
	if level_scene:
		get_tree().change_scene_to_file(level_scene)
	else:
		get_tree().reload_current_scene()
