class_name TypeStrikePlayer
extends CharacterBody3D

@export var player_rails : PlayerRails
@export var textarea : TextEdit

@onready var audio_lost_health := $"../LostHealth" as AudioStreamPlayer3D

var enemy_map : Dictionary
var enemies : Array[EnemyBase] = []
var active_spawner : EnemySpawner
var current_target := -1

var typed_text := ""

func _ready():
	textarea.text_changed.connect(_text_input)
	textarea.grab_focus()
	player_rails.path_completed.connect(unfocus_input)
	Messenger.enemy_spawned.connect(enemy_spawned)
	Messenger.pause_changed.connect(handle_pause_changed)
	Messenger.level_begin.emit()

func _process(delta):
	if not get_tree().paused and PlayerState.health > 0:
		textarea.grab_focus()

func _text_input():
	if PlayerState.health <= 0:
		return
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

	if current_target >= 0 and not Input.is_key_pressed(KEY_ENTER):
		attack_target(key_typed)

func _on_text_edit_text_set():
	typed_text = ""

func get_target(letter: String) -> int:
	for i in enemy_map.keys():
		var enemy = enemy_map.get(i)
		if is_instance_valid(enemy):
			var enemy_word = enemy.word
			if enemy_word.begins_with(letter):
				return i
		else:
			enemy_map.erase(i)
	return -1

func attack_target(letter : String):
	var enemy = enemy_map.get(current_target)
	if is_instance_valid(enemy):
		var remaining = enemy.erase(letter)
		if remaining <= 0:
			remove_target()
	else:
		remove_target()

func remove_target():
	if current_target == -1:
		return
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
	enemies = spawned_enemies
	Messenger.wave_started.emit()

func handle_pause_changed(paused: bool):
	if not paused:
		textarea.grab_focus()

func _on_area_3d_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body is EnemyBase:
		audio_lost_health.play()
		Messenger.player_take_damage.emit()
		body.queue_free()
