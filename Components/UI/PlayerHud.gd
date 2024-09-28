extends Control

@export var score_label : Label
@export var streak_label : Label

func _ready():
	Messenger.score_changed.connect(_update_score_label)
	Messenger.wrong_letter_typed.connect(_update_streak_label)

func _update_streak_label(streak: int = 0):
	streak_label.text = "%d" % streak

func _update_score_label(streak: int, score: int):
	score_label.text = "%d" % score
	_update_streak_label(streak)
