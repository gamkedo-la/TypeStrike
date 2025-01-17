extends MeshInstance3D

@export var max_glitch := 0.2
@export var audio_stream : AudioStreamPlayer

var glitch_amount := 0.0
var mat : ShaderMaterial
@onready var timer = $Timer
@onready var glitch_reduce_timer = $GlitchReduceTimer

func _ready():
	mat = get_active_material(0) as ShaderMaterial
	_set_glitch_timer()
	audio_stream.play()
	var wav_stream: AudioStreamWAV = audio_stream.stream as AudioStreamWAV
	var bpm = audio_stream.stream.get_bpm()
	print ("stream bpm: %3.2f" % bpm)

func _process(delta):
	glitch_amount = maxf(0.0, glitch_amount - delta)
	mat.set_shader_parameter("offset_scale", glitch_amount)
	
	audio_stream.get_playback_position()
	
	if timer.is_stopped() and is_zero_approx(glitch_amount):
		_set_glitch_timer()

func _set_glitch_timer():
	timer.timeout.connect(_begin_glitch)
	timer.wait_time = randi_range(0, 3)
	timer.start()

func _begin_glitch():
	glitch_amount = max_glitch
