extends Node

var phrases : Array[ShuffleBag]

var cutoffs = [
	2, #TINY
	4, #SHORT
	6, #MEDIUM
	8, #LONG
	10, #XLONG
	1000, #WTF
]

var file_length = 374976.0

func _init():
	var dictionary_file = FileAccess.open("res://Data/en/word_list_sorted_by_length.txt", FileAccess.READ)

	for i in cutoffs.size():
		phrases.append(ShuffleBag.new())

	var section = TS_Enums.PhraseLength.TINY
	var section_phrases = []
	while not dictionary_file.eof_reached():
		var phrase = dictionary_file.get_line()
		if phrase.is_empty():
			continue
		if phrase.length() > cutoffs[section]:
			phrases[section].populate(section_phrases)
			section_phrases.clear()
			section += 1
		section_phrases.append(phrase.to_lower())
	phrases[section].populate(section_phrases)
	phrases.map(func(b : ShuffleBag): b.reshuffle())

func get_random_phrase(length : TS_Enums.PhraseLength):
	return phrases[length].random()
