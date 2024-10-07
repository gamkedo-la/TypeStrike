extends Node3D

@export var rotation_axis : Vector3
@export var rotation_rate : float = 10.0
@export var scale_factor : float = 5.0
@export var scale_frequency : float = 2.0

var initial_scale : Vector3
var time_start := 0.0
var time_now := 0.0

func _ready():
	initial_scale = basis.get_scale()
	time_start = Time.get_ticks_msec()

func _physics_process(delta):
	time_now = Time.get_ticks_msec()
	var elapsed_seconds = (time_now - time_start) / 1000.0
	var sin_remapped = remap(sin(elapsed_seconds * scale_frequency), -1, 1, 0, 1)
	var local_scale = sin_remapped * scale_factor * Vector3.ONE
	global_rotate(rotation_axis, rotation_rate * delta)
	scale = local_scale + initial_scale
