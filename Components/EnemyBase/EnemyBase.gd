class_name EnemyBase
extends Node3D

signal focus_lost

@export var word : String
@export var phrase_length : TS_Enums.PhraseLength = TS_Enums.PhraseLength.SHORT
@export var collision_body : CollisionObject3D
@onready var cpu_particles_3d = $CPUParticles3D
@onready var animation_player = $AnimationPlayer

var word_index : int = 0

func _ready():
	word = TypingPhrases.get_random_phrase(phrase_length)
	Messenger.enemy_spawned.emit(self)
	if animation_player:
		animation_player.play("scale_in")

func get_body_position():
	return self.global_position

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
