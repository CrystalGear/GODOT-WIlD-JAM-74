extends Node
class_name Option_Manager

# These need to be set on the options slider too.
const MIN_MOUSE_SENSE: float = 0.001
const MAX_MOUSE_SENSE: float = 0.5

# Variable declarations with 'set' and 'get' for encapsulation
# These setters and getters force the values to use the same validation that calling these externally uses
@export_range(MIN_MOUSE_SENSE, MAX_MOUSE_SENSE) var mouse_sensitivity: float = 0.5
@export_range(0,1) var master_volume: float = 1.0
@export_range(0,1) var music_volume: float = 1.0
@export_range(0,1) var sfx_volume: float = 1.0

# Setters
func Set_Mouse_Sensitivity(value: float) -> void:
	
	if value >= MIN_MOUSE_SENSE and value <= MAX_MOUSE_SENSE:
		mouse_sensitivity = value
	else:
		print("Mouse sensitivity out of valid range")

func Set_Master_Volume(value: float) -> void:
	if value >= 0.0 and value <= 1.0:
		master_volume = value
	else:
		print("Master volume out of valid range")

func Set_Music_Volume(value: float) -> void:
	if value >= 0.0 and value <= 1.0:
		music_volume = value
	else:
		print("Music volume out of valid range")

func Set_SFX_Volume(value: float) -> void:
	if value >= 0.0 and value <= 1.0:
		sfx_volume = value
	else:
		print("SFX volume out of valid range")

# Getters
func Get_Mouse_Sensitivity() -> float:
	return mouse_sensitivity

func Get_Master_Volume() -> float:
	return master_volume

func Get_Music_Volume() -> float:
	return music_volume

func Get_SFX_Volume() -> float:
	return sfx_volume
