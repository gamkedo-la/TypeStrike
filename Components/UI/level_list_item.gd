extends IMenuButton
class_name LevelListItem

@export var level_data: LevelData
@onready var normal_frame = $NormalFrame
@onready var hover_frame = $HoverFrame

func _ready():
	$Label.text = level_data.level_name
	focus_entered.connect(func(): hover_frame.show())
	mouse_entered.connect(func(): hover_frame.show())
	focus_exited.connect(func(): hover_frame.hide())
	mouse_exited.connect(func(): hover_frame.hide())
	pressed.connect(_load_scene())

func _pressed():
	_load_scene()
	
func _load_scene():
	return func():
		get_tree().change_scene_to_file(level_data.level_path)	
	
