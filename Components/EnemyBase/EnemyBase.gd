@tool
class_name EnemyBase
extends CharacterBody3D

@export var path_position : float = 0.5:
	set(new_position):
		path_position = new_position
		var parent = get_parent()
		if parent == null:
			return
		var ancestor = parent.get_parent()
		if ancestor == null:
			return
		var spawner = ancestor as EnemyDistanceSpawner
		if spawner:
			var path_follow: PathFollow3D = spawner.player_path
			var curve = path_follow.get_parent().curve
			var dist = path_position * curve.get_baked_length()
			$"Marker3D".global_position = curve.sample_baked(dist)

@export var move_speed : float = 5.0
@export var word : String
var original_word : String
@export var target : TypeStrikePlayer
@export var label : RichTextLabel
var word_index : int = 0
@export var text_material : Material

@onready var typed_label : Label3D = $"Node3D/TypedChars"
@onready var typed_bg : Label3D = $"Node3D/TypedChars/TypedBackground"
@onready var remaining_label : Label3D = $"Node3D/RemainingChars"
@onready var remaining_bg : Label3D = $"Node3D/RemainingChars/RemainingBackground"

var background_char = "▋"
var in_front = false

func _ready():
	word = TypingPhrases.get_random_phrase()
	_update_label()
	$SubViewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	Messenger.enemy_spawned.emit(self)

func erase(letter : String) -> int:
	if not in_front:
		_move_to_front()

	if word[word_index] == letter:
		word_index += 1
		if word_index < word.length() && word[word_index] == " ":
			word_index += 1
		_update_label()
		Messenger.correct_letter_typed.emit()
	else:
		Messenger.wrong_letter_typed.emit()

	if word_index >= word.length():
		queue_free()
		Messenger.enemy_defeated.emit()
	return word.length() - word_index

func clear_label():
	remaining_label.text = word
	word_index = 0
	_update_label()

func _physics_process(delta):
	if target:
		look_at(target.global_position, Vector3.UP)
		velocity = -global_basis.z * move_speed
		move_and_slide()

func _move_to_front():
	in_front = true
	$SubViewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	remaining_bg.visible = true
	typed_bg.visible = true
	typed_bg.render_priority = 10
	remaining_bg.render_priority = 10
	remaining_label.render_priority = 20
	typed_label.render_priority = 20

func _update_label():
	var typed = word.substr(0, word_index)
	var remaining = word.substr(word_index)
	var offset = ((typed.length() - remaining.length()) / 2.0) * 38.0
	var offset_bg = ((typed.length() - remaining.length()) / 2.0) * 37.0
	typed_label.offset.x = offset
	typed_label.text = typed
	remaining_label.text = remaining
	remaining_label.offset.x = offset
	typed_bg.text = background_char.repeat(typed.length())
	remaining_bg.text = background_char.repeat(remaining.length())
	typed_bg.offset.x = offset_bg
	remaining_bg.offset.x = offset_bg
	#var label_text = "[center][font_size=32][color=DEEP_SKY_BLUE]%s[/color]%s[/font_size][/center]" % [typed, remaining]
	#label.text = label_text
