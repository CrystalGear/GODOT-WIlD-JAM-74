extends AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.register_audio_player(self)

