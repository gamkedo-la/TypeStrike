extends PanelContainer
class_name TableRow

@onready var col_0 = $row/col_0
@onready var col_1 = $row/col_1
@onready var col_2 = $row/col_2

func _ready():
	set_highlight(false)

func set_highlight(highlight: bool):
	theme_type_variation = "TableRowHighlight" if highlight else "TableRow"

func set_data(data: String, col: int):
	var col_name = "row/col_" + str(col)
	var col_node: Label = get_node_or_null(col_name) as Label
	if col_node is Label:
		col_node.text = data
