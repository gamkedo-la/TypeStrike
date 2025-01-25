extends Label

@onready var timer = $Timer

@export var max_dots := 3
@export var base_message := "Loading"

var current_dots = 0

func _ready():
	timer.timeout.connect(_update_message)

func _update_message():
	current_dots = (current_dots + 1) % (max_dots+1)
	text = base_message + ".".repeat(current_dots)
