extends Control

@export var menus : Array[IMenu]

var active := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if menus.size() > 0:
		_set_active(0)
	for menu in menus:
		menu.switch_menu.connect(_set_active)
		menu.exit_menu.connect(_set_active.bind(0))

func _set_active(active_index: int):
	if active_index >= menus.size():
		return
	active = active_index
	_toggle_items()
	
func _toggle_items():
	for i in menus.size():
		if i == active:
			menus[i].show()
			menus[i].process_mode = Node.PROCESS_MODE_INHERIT
		else:
			menus[i].hide()
			menus[i].process_mode = Node.PROCESS_MODE_DISABLED
