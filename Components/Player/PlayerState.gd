extends Node

var letter_value_base := 10
var score := 0
var streak := 0
var bonus := 1

func _ready():
	Messenger.wrong_letter_typed.connect(_break_streak)
	Messenger.enemy_defeated.connect(_update_player_score)

func _break_streak():
	streak = 0
	bonus = 0

func _update_player_score():
	streak += 1
	bonus = _calculate_bonus()
	var gained = letter_value_base + bonus
	score += gained
	Messenger.score_changed.emit(streak, score, gained)

func _calculate_bonus() -> int:
	if streak >= 25:
		return 500
	if streak >= 15:
		return 200
	if streak >= 5:
		return 100
	return 0
