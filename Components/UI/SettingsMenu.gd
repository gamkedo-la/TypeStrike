extends IMenu

var filter_mode := Viewport.SCALING_3D_MODE_BILINEAR
@onready var viewport: Window = get_tree().root
@onready var resolution_changer: OptionButton = %ResolutionOptions
@onready var master_volume_slider: Slider = %MasterVolume
@onready var music_volume_slider: Slider = %MusicVolume
@onready var sfx_volume_slider = %SFXVolume
@onready var debounce: Timer = %VolumeDebounceTimer
@onready var back_button: Button = $"MarginContainer/HBoxContainer/BackButton"

@onready var MASTER_BUS_ID = AudioServer.get_bus_index("Master")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")

var final_mv_value: float = 0.0

func _ready():
	viewport.scaling_3d_mode = filter_mode
	resolution_changer.item_selected.connect(_handle_resolution_change)
	master_volume_slider.value_changed.connect(func(v: float):
		_handle_volume_change(v, MASTER_BUS_ID, PlayerPrefs.P_MASTER_VOLUME))
	music_volume_slider.value_changed.connect(func(v: float):
		_handle_volume_change(v, MUSIC_BUS_ID, PlayerPrefs.P_MUSIC_VOLUME))
	sfx_volume_slider.value_changed.connect(func(v: float):
		_handle_volume_change(v, SFX_BUS_ID, PlayerPrefs.P_SFX_VOLUME))
	back_button.pressed.connect(func():
		exit_menu.emit())
	_init_values_from_prefs()

func _init_values_from_prefs():
	var prefs = PlayerPrefsManager.prefs as PlayerPrefs
	master_volume_slider.value = prefs.master_volume
	music_volume_slider.value = prefs.music_volume
	sfx_volume_slider.value = prefs.sfx_volume

func _handle_resolution_change(index: int) -> void:
	var description = resolution_changer.get_item_text(index)
	var ratio = description.replace("%", "").to_float() / 100.0
	viewport.scaling_3d_scale = ratio

# Ensures that we're not updating the volume every time
# the slider value changes.
func _handle_volume_change(value: float, bus_id: int, prefs_name: String, ) -> void:
	if not debounce.is_stopped():
		debounce.stop()
		debounce.timeout.disconnect(_update_volume)
	debounce.timeout.connect(_update_volume.bind(value, bus_id, prefs_name))
	debounce.start()

func _update_volume(value: float, bus_id: int, prefs_name: String) -> void:
	debounce.timeout.disconnect(_update_volume)
	PlayerPrefsManager.update_prefs({prefs_name: value})
	AudioServer.set_bus_volume_db(bus_id, linear_to_db(value))
