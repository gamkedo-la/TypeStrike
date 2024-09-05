class_name EnemySpawner
extends Node3D

@export var enemy_type : PackedScene

@onready var spawn_timer := $SpawnTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_timer.timeout.connect(_on_timer_timeout)
	_init_dictionary()

func _init_dictionary():
	var file = FileAccess.open("res://Data/en/easy.txt", FileAccess.READ)
	var contents = file.get_as_text()
	

func _on_timer_timeout():
	var enemy = enemy_type.instantiate()
	add_child(enemy)
