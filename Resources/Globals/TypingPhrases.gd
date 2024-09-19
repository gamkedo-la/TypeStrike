extends Node

@export var phrases : Array[String]

func _init():
	var dictionary_file = FileAccess.open("res://Resources/dictionary.txt", FileAccess.READ)
	while not dictionary_file.eof_reached():
		phrases.append(dictionary_file.get_line())
	
	print("phrases contains {0} elements".format(phrases.size()))

func get_random_phrase():
	return phrases.pick_random()
