@tool
extends Node3D
class_name EnemyMarker

@export var path : Path3D
## Distance along path in meters
@export var path_position := 0.5:
	set(p):
		if path:
			var curve := path.curve
			path_position = clampf(p, 0, curve.get_baked_length())
			var curve_position = curve.sample_baked(path_position)
			var marker := $"Marker"
			if marker:
				marker.global_position = path.to_global(curve_position)
				for child in get_children():
					child.look_at(Vector3(marker.global_position.x, child.global_position.y, marker.global_position.z))
		else:
			path_position = p
			printerr("Need to set path to evaluate path_position")
	get:
		return path_position

var enemy : EnemyBase:
	get:
		for child in get_children():
			if child is EnemyBase:
				return child
		return null

func _notification(what):
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		_update_marker_position()

func _ready():
	if Engine.is_editor_hint():
		set_notify_transform(true)
		path_position = path_position
		if enemy:
			$"Marker/Label3D".text = name
	else:
		_hide_marker()
		if enemy:
			enemy.process_mode = Node.PROCESS_MODE_DISABLED
			enemy.hide()
	
func enable_enemy():
	if enemy:
		enemy.process_mode = Node.PROCESS_MODE_INHERIT
		enemy.show()

func _hide_marker():
	var marker := $"Marker"
	marker.hide()

func _update_marker_position():
	if path:
		var curve := path.curve
		var dist := path_position * curve.get_baked_length()
		var curve_position = curve.sample_baked(dist)
		var marker := $"Marker"
		if marker:
			marker.global_position = curve_position
