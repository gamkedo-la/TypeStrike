extends Node

signal correct_letter_typed
signal wrong_letter_typed
signal enemy_defeated(enemy: EnemyBase)
signal player_take_damage
signal player_died
signal wave_started
signal wave_defeated
signal enemy_spawned(enemy: EnemyBase)
signal score_changed(streak: int, score: int, gained: int)
signal pause_changed(paused: bool)
