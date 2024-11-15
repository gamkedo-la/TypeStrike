@tool
extends Node3D
class_name EnemyMarker

@onready var enemy_marker = $EnemyMarker
@onready var path_marker = $PathMarker

@export var enemy_template : PackedScene
@export var path : Path3D
## Distance along path in meters

@export var path_position := 0.5:
	set(p):
		if path:
			var curve := path.curve
			path_position = clampf(p, 0, curve.get_baked_length())
			var curve_position = curve.sample_baked(path_position)
			if path_marker:
				path_marker.global_position = path.to_global(curve_position)
		else:
			path_position = p
	get:
		return path_position

func _notification(what):
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		_update_marker_position()

func _ready():
	if Engine.is_editor_hint():
		set_notify_transform(true)
		_update_marker_position()
	else:
		_hide_markers()
	
func enable_enemy():
	if enemy_template and enemy_template.can_instantiate():
		var enemy = enemy_template.instantiate() as Node3D
		add_child(enemy)
		enemy.position = enemy_marker.position

func _hide_markers():
	$"EnemyMarker".hide()
	$"PathMarker".hide()

func _update_marker_position():
	if path:
		var curve := path.curve
		var dist := path_position * curve.get_baked_length()
		var curve_position = curve.sample_baked(dist)
		if path_marker:
			path_marker.global_position = curve_position
