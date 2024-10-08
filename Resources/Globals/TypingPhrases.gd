extends Node

var phrases : ShuffleBag

func _init():
	phrases = ShuffleBag.new()
	var dictionary_file = FileAccess.open("res://Data/en/cc0_word_list_with_fewer_offensive_words.txt", FileAccess.READ)
	var phrase_array = []
	while not dictionary_file.eof_reached():
		var phrase = dictionary_file.get_line()
		if not phrase.is_empty():
			phrase_array.append(phrase)
	phrases.populate(phrase_array)

func get_random_phrase():
	return phrases.random()
