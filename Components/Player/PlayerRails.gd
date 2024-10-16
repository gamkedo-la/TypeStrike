class_name PlayerRails
extends PathFollow3D

@export var speed : float = 2.0

signal path_completed

var current_speed : float
var should_move : bool = true

func _ready():
	current_speed = speed
	Messenger.wave_started.connect(stop_progress)
	Messenger.wave_defeated.connect(continue_progress)

func _process(delta):
	if should_move:
		progress = progress + (delta * current_speed)
	if progress_ratio >= 1.0:
		path_completed.emit()

func _input(event):
	if event.is_action_pressed("fast_forward"):
		current_speed = speed * 4.0
	if event.is_action_released("fast_forward"):
		current_speed = speed

func stop_progress():
	#should_move = false
	current_speed = speed * 0.25
	
func continue_progress():
	#should_move = true
	current_speed = speed
