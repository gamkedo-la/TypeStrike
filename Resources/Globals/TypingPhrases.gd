extends Node

@export var phrases : Array[String]

func _init():
	var dictionary_file = FileAccess.open("res://Resources/dictionary.txt", FileAccess.READ)
	while not dictionary_file.eof_reached():
		var phrase = dictionary_file.get_line()
		if not phrase.is_empty():
			phrases.append(phrase)

func get_random_phrase():
	return phrases.pick_random()
