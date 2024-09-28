extends Node

var letter_value_base = 10
var score : int = 0
var streak : int = 0
var multiplier : int = 1

func _ready():
	Messenger.correct_letter_typed.connect(_update_player_score)
	Messenger.wrong_letter_typed.connect(_break_streak)

func _break_streak():
	streak = 0
	multiplier = 1

func _update_player_score():
	var old_score = score
	streak += 1
	_calculate_multiplier()
	score += letter_value_base * multiplier
	Messenger.score_changed.emit(old_score, score)
	
func _calculate_multiplier():
	multiplier = 1
