class_name EnemyBase
extends CharacterBody3D

@export var move_speed : float = 5.0
@export var word : String
@export var target : TypeStrikePlayer

func _init():
	word = [
		"bright future",
		"luminous glow",
		"gentle breeze",
		"whispered song",
		"golden sunset",
		"silent ocean",
		"vivid dreams",
		"radiant smile",
		"charming tale",
		"joyful moments",
	].pick_random()

func _ready():
	$SubViewport/Panel/Label.text = word

func erase(letter : String) -> String:
	if word.begins_with(letter):
		word = word.erase(0, 1)
		if word.begins_with(" "):
			word = word.erase(0, 1)
		$SubViewport/Panel/Label.text = word
	if word.length() <= 0:
		queue_free()
	return word

func _physics_process(delta):
	if target:
		look_at(target.global_position)
		var direction = target.global_position - self.global_position
		rotation.y = atan2(direction.z, direction.x)
		#velocity = -basis.z * move_speed
		#velocity = Vector3(0, 0, move_speed)
		move_and_slide()
