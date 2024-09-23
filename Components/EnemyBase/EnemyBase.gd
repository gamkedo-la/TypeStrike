class_name EnemyBase
extends CharacterBody3D

@export var move_speed : float = 5.0
@export var word : String
@export var target : TypeStrikePlayer
@export var label : Label

func _ready():
	word = TypingPhrases.get_random_phrase()
	label.text = word

func erase(letter : String) -> String:
	if word.begins_with(letter):
		word = word.erase(0, 1)
		if word.begins_with(" "):
			word = word.erase(0, 1)
		label.text = word
	if word.length() <= 0:
		queue_free()
		Messenger.enemy_defeated.emit()
	return word

func _physics_process(delta):
	if target:
		look_at(target.global_position, Vector3.UP)
		velocity = -global_basis.z * move_speed
		move_and_slide()
