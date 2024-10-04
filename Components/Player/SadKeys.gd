extends AudioStreamPlayer3D


func _ready():
	Messenger.wrong_letter_typed.connect(play_sound)

func play_sound():
	play()
