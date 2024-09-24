extends IMenuButton

func _pressed():
	handle_button_press()

func handle_button_press():
	get_tree().quit()
