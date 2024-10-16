extends CanvasLayer

@onready var timer_text: Label = $timer_text
@export var timer: float = 120.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer -= delta
	timer_text.text = str(timer)
