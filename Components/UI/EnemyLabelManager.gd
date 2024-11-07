extends Control

@export var label_class : PackedScene

var enemy_phrases: Array[String]
var enemy_nodes: Array[EnemyBase]
var enemy_idx := -1

# Called when the node enters the scene tree for the first time.
func _ready():
	Messenger.enemy_spawned.connect(_register_enemy)

func _register_enemy(enemy: EnemyBase):
	var label : EnemyLabel = label_class.instantiate()
	add_child(label)
	label.set_enemy(enemy)
