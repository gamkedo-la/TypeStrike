extends Node3D
class_name EnemyDistanceSpawner

class Wave:
	var path_placement: float
	var enemy_type: String

@export var player_path : PathFollow3D
@onready var enemy_container : Node3D = $"Enemies"

var enemies: Array
var player_controller: TypeStrikePlayer

func _ready():
	enemies = enemy_container.get_children()
	enemies.sort_custom(func(a:EnemyMarker, b:EnemyMarker):
		return a.path_position < b.path_position
	)

func _process(delta):
	if player_path == null:
		return
	if enemies.size() == 0:
		return
	
	var enemy_pos = enemies[0].path_position
	var player_pos = player_path.progress_ratio
	
	while enemies.size() > 0 && enemies[0].path_position <= player_path.progress_ratio:
		var enemy : EnemyBase = enemies.pop_front().enemy
		enemy.process_mode = PROCESS_MODE_INHERIT
		enemy.show()
		Messenger.enemy_spawned.emit(enemy)
		Messenger.wave_started.emit()
