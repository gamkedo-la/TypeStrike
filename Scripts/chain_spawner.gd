extends Node3D

@export var container : Node3D
@export var chain_length : int = 10
@export var chain_delay : Timer
@export var enemy : PackedScene

var spawned = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	chain_delay.timeout.connect(spawn)

func spawn():
	var inst := enemy.instantiate()
	container.add_child(inst)
	spawned += 1
	if spawned == chain_length:
		chain_delay.stop()
