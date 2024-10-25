extends Control

var filter_mode := Viewport.SCALING_3D_MODE_BILINEAR
@onready var viewport: Window = get_tree().root
@onready var resolution_changer: OptionButton = get_node("%ResolutionOptions")
@onready var master_volume_slider: Slider = get_node("%MasterVolume")
@onready var debounce: Timer = get_node("%VolumeDebounceTimer")

var final_mv_value: float = 0.0

func _ready():
	viewport.scaling_3d_mode = filter_mode
	resolution_changer.item_selected.connect(_handle_resolution_change)
	master_volume_slider.value_changed.connect(_handle_master_volume_change)
	_init_values_from_prefs()

func _init_values_from_prefs():
	var prefs: PlayerPrefs = PlayerPrefsManager.prefs
	master_volume_slider.value = prefs.master_volume

func _handle_resolution_change(index: int) -> void:
	var description = resolution_changer.get_item_text(index)
	var ratio = description.replace("%", "").to_float() / 100.0
	viewport.scaling_3d_scale = ratio

# Ensures that we're not updating the volume every time
# the slider value changes.
func _handle_master_volume_change(value: float) -> void:
	if not debounce.is_stopped():
		debounce.stop()
		debounce.timeout.disconnect(_update_master_volume)
	debounce.timeout.connect(_update_master_volume.bind(value))
	debounce.start()

func _update_master_volume(value: float) -> void:
	debounce.timeout.disconnect(_update_master_volume)
	PlayerPrefsManager.update_prefs({PlayerPrefs.P_MASTER_VOLUME: value})
	print("new volume %.2d" % value)
