extends EnemyBase

@export var radius := 30
@export var speed := 0.1

@onready var rads_per_sec := (PI * speed) / PI
var elapsed := 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsed += delta
	var theta = elapsed * rads_per_sec
	var r = radius * cos(2 * theta)
	var x = r * cos(theta)
	var y = r * sin(theta)
	$dragonfly2.position = Vector3(x, y, 0)

func get_body_position():
	return $"dragonfly2".global_position
