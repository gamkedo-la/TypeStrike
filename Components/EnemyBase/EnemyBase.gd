class_name EnemyBase
extends CharacterBody3D

signal focus_lost


@export var move_speed : float = 5.0
@export var word : String
@export var target : TypeStrikePlayer

var word_index : int = 0


func _ready():
	word = TypingPhrases.get_random_phrase()

func erase(letter : String) -> int:
	if word[word_index] == letter:
		word_index += 1
		if word_index < word.length() && word[word_index] == " ":
			word_index += 1
		Messenger.correct_letter_typed.emit()
	else:
		Messenger.wrong_letter_typed.emit()

	if word_index >= word.length():
		queue_free()
		Messenger.enemy_defeated.emit()
	return word.length() - word_index

func clear_label():
	word_index = 0
	focus_lost.emit()

func _physics_process(delta):
	if target:
		look_at(target.global_position, Vector3.UP)
		velocity = -global_basis.z * move_speed
		move_and_slide()
