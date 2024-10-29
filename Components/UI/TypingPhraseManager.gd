extends Control

@export var label_class : PackedScene

var enemy_phrases: Array[String]
var enemy_nodes: Array[EnemyBase]
var enemy_idx := -1

# Called when the node enters the scene tree for the first time.
func _ready():
	Messenger.enemy_spawned.connect(_register_enemy)
	pass # Replace with function body.

func _register_enemy(enemy: EnemyBase):
	var label : RichTextLabel = label_class.instantiate()
	label.text = enemy.name
	var pos2d = get_viewport().get_camera_3d().unproject_position(enemy.global_position)
	label.position = pos2d
	add_child(label)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
