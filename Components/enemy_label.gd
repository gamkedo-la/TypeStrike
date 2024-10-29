extends Control
class_name EnemyLabel

var enemy : EnemyBase
var label_template : String

@onready var cam : Camera3D = get_viewport().get_camera_3d()
@onready var enemy_label: RichTextLabel = $PanelContainer/EnemyLabel

func _ready():
	Messenger.correct_letter_typed.connect(_update_text)

func set_enemy(target_enemy: EnemyBase):
	label_template = enemy_label.text
	enemy = target_enemy
	enemy_label.text = enemy.word
	enemy.tree_exiting.connect(enemy_defeated)
	enemy.focus_lost.connect(_update_text)
	process_mode = Node.PROCESS_MODE_INHERIT
	show()

func enemy_defeated():
	queue_free()

func _process(delta):
	if (enemy):
		var pos2d = cam.unproject_position(enemy.global_position)
		offset_left = pos2d.x - (enemy_label.get_content_width() / 2)
		offset_top = pos2d.y

func _update_text():
	var typed = enemy.word.substr(0, enemy.word_index)
	var remaining = enemy.word.substr(enemy.word_index)
	enemy_label.text = label_template % [typed, remaining]
	
