extends Button
class_name IMenuButton

@export var trigger_key : InputEventKey

func _unhandled_key_input(event):
	var key_event = event as InputEventKey
	if key_event.pressed && key_event.keycode == trigger_key.keycode:
		pressed.emit()
		_pressed()
