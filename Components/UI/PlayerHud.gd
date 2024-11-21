extends Control

@export var health_label: Label
@export var score_label : Label
@export var streak_label : Label

func _ready():
	_update_health_label()
	Messenger.player_take_damage.connect(_update_health_label)
	Messenger.score_changed.connect(_update_score_label)
	Messenger.wrong_letter_typed.connect(_update_streak_label)
	Messenger.pause_changed.connect(handle_pause_changed)

func _input(event):
	if event.is_action_pressed("pause"):
		var paused = not get_tree().paused
		get_tree().paused = paused
		Messenger.pause_changed.emit(paused)

func _update_health_label(health: int = PlayerState.health):
	health_label.text = str(health)

func _update_streak_label(streak: int = 0):
	streak_label.text = "%d" % streak

func _update_score_label(streak: int, score: int, gained: int):
	score_label.text = "%d" % score
	_update_streak_label(streak)

func handle_pause_changed(paused: bool):
	$"PauseMenu".visible = paused
	if paused:
		$"PauseMenu".grab_focus()
