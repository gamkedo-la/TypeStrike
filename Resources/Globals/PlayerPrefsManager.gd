extends Node

const file_path : String = "user://playerprefs.res"

var prefs : PlayerPrefs

signal player_prefs_changed(prefs: PlayerPrefs)
signal player_prefs_save_started
signal player_prefs_save_complete

func _ready():
	_load_prefs()

func _load_prefs():
	if ResourceLoader.exists(file_path):
		prefs = load(file_path)
	else:
		prefs = PlayerPrefs.new()

func update_prefs(props : Dictionary):
	for k in props.keys():
		prefs.set(k, props.get(k))
	ResourceSaver.save(prefs, file_path)

func _load_prefs_from_disk():
	prefs = load(file_path)

func _save_prefs_to_disk():
	ResourceSaver.save(prefs, file_path)
