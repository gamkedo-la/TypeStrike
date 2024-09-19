extends RefCounted
class_name ShuffleBag

var initial : Array
var bag : Array

func populate(items : Array) -> void:
	initial = items
	reshuffle()

func reshuffle():
	bag = initial.duplicate()
	bag.shuffle()

func random() -> Variant:
	if bag.is_empty():
		reshuffle()
	
	return bag.pop_front()
