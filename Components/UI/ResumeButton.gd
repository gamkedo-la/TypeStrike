extends IMenuButton

func _pressed():
	get_tree().paused = false
	Messenger.pause_changed.emit(false)
