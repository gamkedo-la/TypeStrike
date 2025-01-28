extends IMenuButton

func _ready():
	pressed.connect(func():
		get_tree().paused = false
		Messenger.pause_changed.emit(false))
