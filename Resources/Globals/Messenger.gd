extends Node

signal correct_letter_typed
signal wrong_letter_typed
signal enemy_defeated
signal player_take_damage
signal wave_started
signal wave_defeated
signal enemy_spawned(enemy: EnemyBase)
signal score_changed(streak: int, score: int)
signal pause_changed(paused: bool)
