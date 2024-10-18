extends CanvasLayer

@onready var timer_text: Label = $timer_text
@export var time_limit: float = 120.0
var timer: float
var continueCountdown: bool = true

# Sets the value of timer to be equal to time_limit on start.
func _ready() -> void:
	timer = time_limit

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (continueCountdown):
		timer -= delta
		timer_text.text = str(timer)
		
		if (timer <= 0):
			timer = 0
			continueCountdown = false

# Returns a float indicating how long remains on the timer.
func return_normalized_time_remaining() -> float:
	return clamp(timer / time_limit, 0 ,1)
