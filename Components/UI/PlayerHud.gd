extends Control

@export var letter_value : int = 10
@export var score_label : Label

func _ready():
	Messenger.score_changed.connect(_update_score_label)
	
func _update_score_label(old_score: int, new_score: int):
	score_label.text = "%d" % new_score
