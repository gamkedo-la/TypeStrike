extends IMenu

@onready var back_button = %BackButton

func _ready():
	back_button.pressed.connect(_exit)

func _exit():
	if exit_menu.get_connections().size() > 0:
		exit_menu.emit()
