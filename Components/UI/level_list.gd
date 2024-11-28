@tool
extends GridContainer
class_name LevelList

@export var level_list_item : PackedScene
@export var levels : Array[LevelData]

func _ready():
	for level in levels:
		var selector = level_list_item.instantiate() as LevelListItem
		selector.initialize(level)
		add_child(selector)
