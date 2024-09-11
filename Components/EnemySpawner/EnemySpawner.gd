class_name EnemySpawner
extends Area3D

@export var enemy_type : PackedScene
@export var spawn_points : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	body_shape_entered.connect(_on_body_entered)

func _on_timer_timeout():
	var enemy = enemy_type.instantiate()
	add_child(enemy)

func _on_body_entered(_body_rid: RID, body: Node, _body_shape_index: int, _local_shape_index: int):
	if body is TypeStrikePlayer:
		var player = body as TypeStrikePlayer
		body_shape_entered.disconnect(_on_body_entered)
		var enemies : Array[EnemyBase] = []
		for node in $SpawnPoints.get_children():
			#node.look_at(player.global_position)
			node.look_at(player.position)
			var enemy = enemy_type.instantiate() as EnemyBase
			node.add_child(enemy)
			enemy.target = body
			enemies.append(enemy)
		player.begin_wave(enemies)
