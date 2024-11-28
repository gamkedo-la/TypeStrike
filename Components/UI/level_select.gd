extends IMenu

@onready var back_button = %BackButton

# Called when the node enters the scene tree for the first time.
func _ready():
	back_button.pressed.connect(func():
		exit_menu.emit())
