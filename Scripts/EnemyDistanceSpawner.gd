extends Node3D

class Wave:
	var path_placement: float
	var enemy_type: String

@export var player_path : PathFollow3D
@onready var enemy_container : Node3D = $"Enemies"

var enemies: Array
var player_controller: TypeStrikePlayer

func _ready():
	#var enemies = enemy_container.get_children()
	enemies = get_child(0).get_children()
	enemies.sort_custom(func(a:EnemyBase, b:EnemyBase): return a.path_position < b.path_position)
	enemies.map(func(e:EnemyBase):
		e.process_mode = Node.PROCESS_MODE_DISABLED
		e.hide()
		)
	
	if player_path == null:
		return
	
	#var player_controller = player_path.find_child("CharacterBody3D")

func _process(delta):
	if player_path == null:
		return
	if enemies.size() == 0:
		return
	
	var enemy_pos = enemies[0].path_position
	var player_pos = player_path.progress_ratio
	
	while enemies.size() > 0 && enemies[0].path_position < player_path.progress_ratio:
		var enemy : EnemyBase = enemies.pop_front()
		enemy.process_mode = PROCESS_MODE_INHERIT
		enemy.show()
		Messenger.enemy_spawned.emit(enemy)
		#player_controller.begin_wave([enemy])
	
	
		#var wave_instance : Node3D = wave.enemy_scene.instantiate()
		#add_child(wave_instance)
		#wave_instance.global_position = player_path.global_position + Vector3(0, 0, -20)
