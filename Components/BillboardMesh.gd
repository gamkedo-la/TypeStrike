extends MeshInstance3D

var min_scale : float = 1.0
var max_scale : float = 30
var base_y : float
var y_offset_scale : float = 1.0

func _ready():
	base_y = position.y

func _physics_process(delta):
	var active_camera = get_viewport().get_camera_3d()
	var dist_to_camera = active_camera.global_position.distance_squared_to(self.global_position)
	var ratio = remap(clampf(dist_to_camera, min_scale, max_scale), min_scale, max_scale, 0, 1.0)
	var position_delta = lerp(-0.3, 1.0, ratio)
	position.y = base_y + position_delta
	#print("base: %f\tdelta: %f\tratio: %f\tdist: %f" % [base_y, position_delta, ratio, dist_to_camera])
