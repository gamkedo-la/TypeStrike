extends Control

var filter_mode := Viewport.SCALING_3D_MODE_BILINEAR
@onready var viewport: Window = get_tree().root
@onready var resolution_changer: OptionButton = get_node("%ResolutionOptions")


func _ready():
	viewport.scaling_3d_mode = filter_mode
	resolution_changer.item_selected.connect(_handle_resolution_change)

func _handle_resolution_change(index: int) -> void:
	var description = resolution_changer.get_item_text(index)
	var ratio = description.replace("%", "").to_float() / 100.0
	viewport.scaling_3d_scale = ratio
