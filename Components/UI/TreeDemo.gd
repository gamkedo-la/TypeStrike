@tool
extends Tree

var root : TreeItem
var rows : Array[TreeItem]

# Called when the node enters the scene tree for the first time.
func _ready():
	root = create_item()
	set_column_title(0, 'player')
	set_column_title(1, 'score')
	set_column_title(2, 'rank')
	
	var score : Array[int] = []
	for i in 10:
		score.append(randi_range(1, 99999))
	score.sort()
	score.reverse()
	
	for i in 10:
		var row = create_item(root)
		row.set_text(0, 'Tyfoo')
		row.set_text(1, str(score[i]))
		row.set_text(2, str(i+1))
		rows.append(row)
	
	set_selected(rows.pick_random(), 0)
	
