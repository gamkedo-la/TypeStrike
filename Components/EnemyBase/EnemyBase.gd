class_name EnemyBase
extends CharacterBody3D

@export var move_speed : float = 5.0
@export var word : String
var original_word : String
@export var target : TypeStrikePlayer
@export var label : RichTextLabel
var word_index : int = 0

func _ready():
	word = TypingPhrases.get_random_phrase()
	_update_label()
	Messenger.enemy_spawned.emit(self)

func erase(letter : String) -> int:
	if word[word_index] == letter:
		word_index += 1
		if word_index < word.length() && word[word_index] == " ":
			word_index += 1
		_update_label()
	if word_index >= word.length():
		queue_free()
		Messenger.enemy_defeated.emit()
	return word.length() - word_index

func _physics_process(delta):
	if target:
		look_at(target.global_position, Vector3.UP)
		velocity = -global_basis.z * move_speed
		move_and_slide()

func _update_label():
	var typed = word.substr(0, word_index)
	var remaining = word.substr(word_index)
	var label_text = "[center][color=DEEP_SKY_BLUE]%s[/color]%s[/center]" % [typed, remaining]
	label.text = label_text
