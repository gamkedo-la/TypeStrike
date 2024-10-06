class_name TypeStrikePlayer
extends CharacterBody3D

@export var player_rails : PlayerRails
@export var textarea : TextEdit

var enemies : Array[EnemyBase] = []
var active_spawner : EnemySpawner
var current_target : int = -1


func _ready():
	textarea.text_changed.connect(_text_input)
	textarea.grab_focus()
	player_rails.path_completed.connect(unfocus_input)
	Messenger.pause_changed.connect(handle_pause_changed)

func _text_input():
	var key_typed = textarea.text[-1].to_lower() if textarea.text.length() > 0 else ""
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
		var remaining = enemy.erase(letter)
		if remaining <= 0:
			remove_target()
	else:
		current_target = -1

func remove_target():
	enemies.remove_at(current_target)
	current_target = -1
	textarea.clear()
	if enemies.size() == 0:
		Messenger.wave_defeated.emit()

func unfocus_input():
	textarea.release_focus()

func enemy_spawned(node: Node):
	if node is EnemyBase:
		var enemy = node as EnemyBase
		enemies.append(enemy)

func begin_wave(spawned_enemies: Array[EnemyBase]):
	enemies = spawned_enemies
	Messenger.wave_started.emit()

func handle_pause_changed(paused: bool):
	if not paused:
		textarea.grab_focus()
