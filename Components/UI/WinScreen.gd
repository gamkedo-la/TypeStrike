extends Control

func _ready():
	visible = false

func on_level_completed():
	visible = true
