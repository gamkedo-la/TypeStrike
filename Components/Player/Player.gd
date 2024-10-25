class_name TypeStrikePlayer
extends CharacterBody3D

@export var player_rails : PlayerRails
@export var textarea : TextEdit

var enemy_map : Dictionary
var enemies : Array[EnemyBase] = []
var active_spawner : EnemySpawner
var current_target := -1

var typed_text := ""

func _ready():
	textarea.text_changed.connect(_text_input)
	textarea.grab_focus()
	player_rails.path_completed.connect(unfocus_input)
	Messenger.pause_changed.connect(handle_pause_changed)
	Messenger.enemy_spawned.connect(enemy_spawned)

func _text_input():
	var key_typed = textarea.text[-1].to_lower() if textarea.text.length() > 0 else ""
	if enemy_map.is_empty():
		return
	if current_target < 0:
		current_target = get_target(key_typed)
	if textarea.text.length() <= typed_text.length():
		var enemy : EnemyBase = enemy_map.get(current_target)
		if enemy:
			enemy.clear_label()
		textarea.clear()
		current_target = -1
	typed_text = textarea.text

	if current_target >= 0:
		attack_target(key_typed)

func _on_text_edit_text_set():
	typed_text = ""

func get_target(letter: String) -> int:
	for i in enemy_map.keys():
		var enemy_word = enemy_map.get(i).word
		if enemy_word.begins_with(letter):
			return i
	return -1

func attack_target(letter : String):
	var enemy : EnemyBase = enemy_map.get(current_target)
	if enemy:
		var remaining = enemy.erase(letter)
		if remaining <= 0:
			remove_target()
	else:
		current_target = -1

func remove_target():
	enemy_map.erase(current_target)
	current_target = -1
	textarea.clear()
	if enemy_map.is_empty():
		Messenger.wave_defeated.emit()

func unfocus_input():
	textarea.release_focus()

func enemy_spawned(node: Node):
	if node is EnemyBase:
		var enemy := node as EnemyBase
		enemy_map[enemy.get_instance_id()] = enemy

func begin_wave(spawned_enemies: Array[EnemyBase]):
	#enemies.append_array(spawned_enemies)
	enemies = spawned_enemies
	Messenger.wave_started.emit()

func handle_pause_changed(paused: bool):
	if not paused:
		textarea.grab_focus()
