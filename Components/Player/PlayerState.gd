extends Node

var letter_value_base := 10
var score := 0
var streak := 0
var multiplier := 1

func _ready():
	Messenger.correct_letter_typed.connect(_update_player_score)
	Messenger.wrong_letter_typed.connect(_break_streak)

func _break_streak():
	streak = 0
	multiplier = 1

func _update_player_score():
	streak += 1
	multiplier = _calculate_multiplier()
	score += letter_value_base * multiplier
	Messenger.score_changed.emit(streak, score)
	
func _calculate_multiplier() -> int:
	if streak >= 200:
		return 4
	if streak >= 100:
		return 3
	if streak >= 20:
		return 2
	return 1
