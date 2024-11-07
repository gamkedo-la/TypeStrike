extends IMenu


func _ready():
	$"Buttons/ResumeButton".pressed.connect(func ():
		get_tree().paused = false
		Messenger.pause_changed.emit(false))
	$Buttons/SettingsButton.pressed.connect(func ():
		switch_menu.emit($Buttons/SettingsButton.menu_index))
