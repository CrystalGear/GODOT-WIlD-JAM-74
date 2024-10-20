extends Control

@onready var master_volume_slider: HSlider = $"Options Backing/MasterVolumeLabel/MasterVolumeSlider"
@onready var music_volume_slider: HSlider = $"Options Backing/MusicVolumeLabel/MusicVolumeSlider"
@onready var sfx_volume_slider: HSlider 	= $"Options Backing/SFXVolumeLabel/SFXVolumeSlider"
@onready var ambient_volume_slider: HSlider = $"Options Backing/AmbientVolumeLabel/AmbientVolumeSlider"
@onready var look_sensitivity_slider: HSlider = $"Options Backing/MouseSensitivityLabel/LookSensitivitySlider"

var b_ready:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_sliders()
	b_ready = true

func _setup_sliders() -> void:
	master_volume_slider.value = OptionsManager.Get_Master_Volume()
	music_volume_slider.value = OptionsManager.Get_Music_Volume()
	sfx_volume_slider.value = OptionsManager.Get_SFX_Volume()
	ambient_volume_slider.value = OptionsManager.Get_Ambient_Volume()
	
	look_sensitivity_slider.min_value = OptionsManager.MIN_MOUSE_SENSE
	look_sensitivity_slider.max_value = OptionsManager.MAX_MOUSE_SENSE
	print("%s in setup" % [look_sensitivity_slider.value])
	look_sensitivity_slider.value = OptionsManager.Get_Mouse_Sensitivity()
	print("%s in setup" % [OptionsManager.Get_Mouse_Sensitivity()])
	print("%s in setup" % [look_sensitivity_slider.value])
	
	
func _on_master_volume_slider_value_changed(value: float) -> void:
	# Early exit to prevent this running before _ready is called on the first frame
	if not b_ready: return
	
	OptionsManager.Set_Master_Volume(value)

func _on_music_volume_slider_value_changed(value: float) -> void:
	# Early exit to prevent this running before _ready is called on the first frame
	if not b_ready: return
	
	OptionsManager.Set_Music_Volume(value)

func _on_sfx_volume_slider_value_changed(value: float) -> void:
	# Early exit to prevent this running before _ready is called on the first frame
	if not b_ready: return
	
	OptionsManager.Set_SFX_Volume(value)

func _on_ambient_volume_slider_value_changed(value: float) -> void:
	# Early exit to prevent this running before _ready is called on the first frame
	if not b_ready: return
	
	OptionsManager.Set_Ambient_Volume(value)

func _on_look_sensitivity_slider_value_changed(value: float) -> void:
	# Early exit to prevent this running before _ready is called on the first frame
	if not b_ready: return
	
	OptionsManager.Set_Mouse_Sensitivity(value)

func _on_button_button_down() -> void:
	LevelManager.show_main_menu()
