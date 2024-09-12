class_name TypeStrikePlayer
extends CharacterBody3D

const english_alpha = "abcdefghijklmnopqrstuvwxyz"

var enemies : Array[EnemyBase] = []
var active_spawner : EnemySpawner
var current_target : int = -1
var textarea : TextEdit

signal wave_defeated

func _ready():
	textarea = $TextEdit
	textarea.text_changed.connect(_text_input)
	textarea.grab_focus()
	wave_defeated.connect(end_wave)

func _text_input():
	var key_typed = textarea.text[-1].to_lower()
	if current_target < 0:
		current_target = get_target(key_typed)
	if current_target >= 0:
		attack_target(key_typed)

func get_target(letter : String):
	for i in range(enemies.size()):
		var enemy_word = enemies[i].word
		if enemy_word.begins_with(letter):
			return i
	return -1

func attack_target(letter : String):
	var enemy = enemies[current_target]
	if enemy:
		var remainder = enemy.erase(letter)
		if remainder.length() <= 0:
			remove_target()
	else:
		current_target = -1

func remove_target():
	enemies.remove_at(current_target)
	current_target = -1
	textarea.clear()
	if enemies.size() == 0:
		wave_defeated.emit()

func enemy_spawned(node: Node):
	print("unit spawned", node.name)
	if node is EnemyBase:
		var enemy = node as EnemyBase
		enemies.append(enemy)

func begin_wave(spawned_enemies: Array[EnemyBase]):
	enemies = spawned_enemies
	stop_progress()

func end_wave():
	continue_progress()

func stop_progress():
	$"..".should_move = false
	
func continue_progress():
	$"..".should_move = true
