class_name TypeStrikePlayer
extends CharacterBody3D

const english_alpha = "abcdefghijklmnopqrstuvwxyz"
var current_spawner : EnemySpawner

var enemies = []
var current_target : int = -1
var current_word : String = ""

func _ready():
	current_spawner = get_node("/root/Level1/EnemySpawner")
	current_spawner.child_entered_tree.connect(_on_enemy_spawned)
	$TextEdit.text_changed.connect(_text_input)
	$TextEdit.grab_focus()
	
func _text_input():
	var key_typed = $TextEdit.text[-1].to_lower()
	if current_target < 0:
		current_target = _get_target(key_typed)
	if current_target >= 0:
		_attack_target(key_typed)

#func _unhandled_input(event):
	#if event is InputEventKey and not event.is_pressed():
		#var typed_event = event as InputEventKey
		#var has_shift = typed_event.shift_pressed
		#var key_typed = PackedByteArray([typed_event.get_keycode_with_modifiers()]).get_string_from_utf8().to_lower()
		#
		#if current_target < 0:
			#current_target = _get_target(key_typed)
		#if current_target >= 0:
			#_attack_target(key_typed)

func _get_target(letter : String):
	for i in range(enemies.size()):
		var enemy_word = enemies[i].word
		if enemy_word.begins_with(letter):
			current_word = ""
			return i
	return -1

func _attack_target(letter : String):
	var enemy = enemies[current_target]
	if enemy:
		var remainder = enemy.erase(letter)
		if remainder.length() <= 0:
			_remove_target()
	else:
		current_target = -1

func _remove_target():
	enemies.remove_at(current_target)
	current_target = -1
	$TextEdit.clear()

func _on_enemy_spawned(node: Node):
	print("enemy spawned", node.name)
	if node is EnemyBase:
		var enemy = node as EnemyBase
		enemies.append(enemy)
