extends PathFollow3D

@export var speed : float = 2.0

var current_speed : float
var should_move : bool = true

func _ready():
	current_speed = speed
func _process(delta):
	if should_move:
		progress = progress + (delta * current_speed)
func _input(event):
	if event.is_action_pressed("fast_forward"):
		current_speed = speed * 4.0
	if event.is_action_released("fast_forward"):
		current_speed = speed
