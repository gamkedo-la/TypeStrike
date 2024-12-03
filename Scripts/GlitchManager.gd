extends MeshInstance3D

@export var max_glitch := 0.2

var glitch_amount := 0.0
var mat : ShaderMaterial
@onready var timer = $Timer
@onready var glitch_reduce_timer = $GlitchReduceTimer

func _ready():
	mat = get_active_material(0) as ShaderMaterial
	_set_glitch_timer()

func _process(delta):
	glitch_amount = maxf(0.0, glitch_amount - delta)
	mat.set_shader_parameter("offset_scale", glitch_amount)
	if timer.is_stopped() and is_zero_approx(glitch_amount):
		_set_glitch_timer()

func _set_glitch_timer():
	timer.timeout.connect(_begin_glitch)
	timer.wait_time = randi_range(0, 3)
	timer.start()

func _begin_glitch():
	glitch_amount = max_glitch

