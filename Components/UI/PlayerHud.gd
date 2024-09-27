extends Control

var enemy_labels = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	Messenger.enemy_spawned.connect(register_enemy_ui)
	pass # Replace with function body.

func register_enemy_ui(enemy: EnemyBase):
	print("enemy spawned")
	var label = RichTextLabel.new()
	enemy_labels[enemy.get_instance_id()] = label
	label.bbcode_enabled = true
	var typed = "abcd"
	var remaining = "efgh"
	var label_text = "[color=DEEP_SKY_BLUE]%s[/color]%s" % [typed, remaining]
	label.text = label_text
	$"TypingPhraseContainer".add_child(label)
	label.set_position(Vector2(200, 200))
