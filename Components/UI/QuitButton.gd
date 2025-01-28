extends IMenuButton

func _ready():
	pressed.connect(handle_button_press)

func handle_button_press():
	get_tree().quit()
