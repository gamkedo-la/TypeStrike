extends AudioStreamPlayer3D


func _ready():
	Messenger.correct_letter_typed.connect(play_sound)

func play_sound():
	play()
