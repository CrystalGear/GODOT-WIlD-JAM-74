class_name Car_part extends Holdable

@export var impact_audio: AudioStream

func _on_body_entered(body: Node) -> void:
	if impact_audio:
		AudioManager.play_clip(impact_audio, position)
