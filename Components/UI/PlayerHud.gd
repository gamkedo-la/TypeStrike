extends Control

@export var score_label : Label
@export var streak_label : Label

@onready var _game_over_scene := preload("res://Components/UI/GameOver.tscn")
@onready var health_progress_bar = $StatsContainer/VBoxContainer/HealthContainer/HealthProgressBar


func _ready():
	_update_health_label()
	Messenger.player_take_damage.connect(_update_health_label)
	Messenger.player_died.connect(_show_game_over)
	Messenger.score_changed.connect(_update_score_label)
	Messenger.wrong_letter_typed.connect(_update_streak_label)
	Messenger.pause_changed.connect(handle_pause_changed)
	Messenger.level_begin.connect(_update_health_label.bind(PlayerState.MAX_HEALTH))

func _input(event):
	if event.is_action_pressed("pause"):
		var paused = not get_tree().paused
		get_tree().paused = paused
		Messenger.pause_changed.emit(paused)

func _update_health_label(health: int = PlayerState.health):
	health_progress_bar.value = health / 5.0

func _show_game_over():
	var game_over := _game_over_scene.instantiate()
	add_child(game_over)

func _update_streak_label(streak: int = 0):
	streak_label.text = "%d" % streak

func _update_score_label(streak: int, score: int, gained: int):
	score_label.text = "%d" % score
	_update_streak_label(streak)

func handle_pause_changed(paused: bool):
	$"PauseMenu".visible = paused
	if paused:
		$"PauseMenu".grab_focus()
