extends CanvasLayer

@onready var timer_text: Label = $timer_text
@export var time_limit: float = 120.0
var timer: float

# Sets the value of timer to be equal to time_limit on start.
func _ready() -> void:
	timer = time_limit

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer -= delta
	timer_text.text = str(timer)

# Returns a float indicating how long remains on the timer.
func return_time_remaining() -> float:
	return timer / time_limit
