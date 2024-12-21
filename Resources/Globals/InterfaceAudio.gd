extends Node

var player2d : AudioStreamPlayer2D

func _ready():
	player2d = AudioStreamPlayer2D.new()
	add_child(player2d)
	player2d.bus = AudioServer.get_bus_name(AudioServer.get_bus_index("SFX"))

func play_audio_2d(clip : AudioStream, boost: float = 0.0):
	player2d.stream = clip
	player2d.volume_db = boost
	player2d.play()
