extends PathFollow3D

@export var speed : float = 2.0

var should_move : bool = true

func _process(delta):
	if should_move:
		progress = progress + (delta * speed)
