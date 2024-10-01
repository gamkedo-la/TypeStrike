extends AudioStreamPlayer3D


# Called when the node enters the scene tree for the first time.
func _ready():
	Messenger.correct_letter_typed.connect(play_sound)

func play_sound():
	play()
