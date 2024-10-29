class_name PlayerRails
extends PathFollow3D

@export var speed : float = 2.0
@export var fast_forward_multiplier : float = 4.0
@export var combat_slow_multiplier : float = 0.25

var fast_forward : float = 1.0
var combat_slow : float = 1.0

signal path_completed

var current_speed : float:
	get:
		return speed * fast_forward * combat_slow


func _ready():
	current_speed = speed
	Messenger.wave_started.connect(stop_progress)
	Messenger.wave_defeated.connect(continue_progress)


func _process(delta):
	progress = progress + current_speed * delta
	if progress_ratio >= 1.0:
		path_completed.emit()

func _input(event):
	if event.is_action_pressed("fast_forward"):
		fast_forward = fast_forward_multiplier
	if event.is_action_released("fast_forward"):
		fast_forward = 1

func stop_progress():
	combat_slow = combat_slow_multiplier
	
func continue_progress():
	combat_slow = 1.0
