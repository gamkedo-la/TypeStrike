extends IMenu

var filter_mode := Viewport.SCALING_3D_MODE_BILINEAR
@onready var viewport: Window = get_tree().root
@onready var master_volume_slider: Slider = %MasterVolume
@onready var music_volume_slider: Slider = %MusicVolume
@onready var sfx_volume_slider = %SFXVolume
@onready var debounce: Timer = %VolumeDebounceTimer
@onready var back_button: Button = %BackButton

@onready var MASTER_BUS_ID = AudioServer.get_bus_index("Master")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var fullscreen_button = %FullscreenButton
@onready var text_size_selector = %TextSizeSelector

var final_mv_value: float = 0.0

func _ready():
	viewport.scaling_3d_mode = filter_mode
	master_volume_slider.value_changed.connect(func(v: float):
		_handle_volume_change(v, MASTER_BUS_ID, PlayerPrefs.P_MASTER_VOLUME))
	music_volume_slider.value_changed.connect(func(v: float):
		_handle_volume_change(v, MUSIC_BUS_ID, PlayerPrefs.P_MUSIC_VOLUME))
	sfx_volume_slider.value_changed.connect(func(v: float):
		_handle_volume_change(v, SFX_BUS_ID, PlayerPrefs.P_SFX_VOLUME))
	back_button.pressed.connect(func():
		exit_menu.emit())
	fullscreen_button.toggled.connect(func(state): _update_display_mode(state))
	text_size_selector.item_selected.connect(func(index: int):
		var cam2d = get_viewport().get_camera_2d()
		var scaling = 1.0 + index
		cam2d.set_zoom(Vector2(scaling, scaling)))
		
	var cam3d = get_viewport().get_camera_3d()
	
	_init_values_from_prefs()

func _init_values_from_prefs():
	var prefs = PlayerPrefsManager.prefs as PlayerPrefs
	master_volume_slider.value = prefs.master_volume
	music_volume_slider.value = prefs.music_volume
	sfx_volume_slider.value = prefs.sfx_volume
	AudioServer.set_bus_volume_db(MASTER_BUS_ID, linear_to_db(prefs.master_volume))
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(prefs.music_volume))
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(prefs.sfx_volume))
	fullscreen_button.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN

# Ensures that we're not updating the volume every time
# the slider value changes.
func _handle_volume_change(value: float, bus_id: int, prefs_name: String, ) -> void:
	if not debounce.is_stopped():
		debounce.stop()
		debounce.timeout.disconnect(_update_volume)
	debounce.timeout.connect(_update_volume.bind(value, bus_id, prefs_name))
	debounce.start()

func _update_display_mode(fullscreen: bool) -> void:
	var display_mode = DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen else DisplayServer.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(display_mode)

func _update_volume(value: float, bus_id: int, prefs_name: String) -> void:
	debounce.timeout.disconnect(_update_volume)
	PlayerPrefsManager.update_prefs({prefs_name: value})
	AudioServer.set_bus_volume_db(bus_id, linear_to_db(value))

func _update_text_size(index: int) -> void:
	printerr("not yet implemented")
