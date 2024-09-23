extends RefCounted
class_name ShuffleBag

var bag : Array
var index : int = 0

func populate(items : Array) -> void:
	bag = items
	reshuffle()

func reshuffle():
	index = 0
	bag.shuffle()

func random() -> Variant:
	if index >= bag.size():
		reshuffle()
	index += 1
	return bag[index-1]
