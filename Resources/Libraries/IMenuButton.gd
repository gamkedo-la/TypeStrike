extends BaseButton
class_name IMenuButton

@onready var pressed_sound = preload("res://Audio/keyboard clack.wav")
@export var trigger_key : InputEventKey

func _ready():
	pressed.connect(func(): InterfaceAudio.play_audio_2d(pressed_sound, 5.0))

func _unhandled_key_input(event):
	var key_event = event as InputEventKey
	if key_event.pressed && key_event.keycode == trigger_key.keycode:
		pressed.emit()
		_pressed()
 
