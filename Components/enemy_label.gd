extends Control
class_name EnemyLabel

var enemy : EnemyBase
var label_template : String

@onready var fade_timer = $FadeTimer
@onready var cam : Camera3D = get_viewport().get_camera_3d()
@onready var enemy_label: RichTextLabel = $PanelContainer/EnemyLabel

func _ready():
	Messenger.correct_letter_typed.connect(_update_text)
	Messenger.score_changed.connect(_show_score_and_fade)
	fade_timer.timeout.connect(_remove)

func set_enemy(target_enemy: EnemyBase):
	label_template = enemy_label.text
	enemy = target_enemy
	enemy_label.text = enemy.word
	enemy.focus_lost.connect(_update_text)
	process_mode = Node.PROCESS_MODE_INHERIT
	show()

func _show_score_and_fade(streak: int, new_score: int, amount_gained: int):
	if not _is_enemy_valid() and fade_timer.is_stopped():
		var amount_text = "+%d" % amount_gained
		enemy_label.text = amount_text
		enemy_label.show()
		fade_timer.start()

func _remove():
	queue_free()

func _process(delta):
	if _is_enemy_valid():
		var pos2d = cam.unproject_position(enemy.global_position)
		offset_left = pos2d.x - (enemy_label.get_content_width() / 2)
		offset_top = pos2d.y
	else:
		offset_top = offset_top - 20 * delta
		var percent_fade = fade_timer.time_left / fade_timer.wait_time
		modulate = Color(1, 1, 1, percent_fade)

func _update_text():
	if _is_enemy_valid():
		var typed = enemy.word.substr(0, enemy.word_index)
		var remaining = enemy.word.substr(enemy.word_index)
		enemy_label.text = label_template % [typed, remaining]

func _is_enemy_valid():
	return not enemy == null and not enemy.is_queued_for_deletion()
