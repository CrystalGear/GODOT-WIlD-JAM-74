extends CanvasLayer

@onready var timer_text: Label = $timer_text
@export var time_limit: float = 300
var time_remaining: float
var continueCountdown: bool = true

# Sets the value of timer to be equal to time_limit on start.
func _ready() -> void:
	add_to_group("gameTimer")	# Add this to a group for easy finding
	time_remaining = time_limit

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (not continueCountdown): return
		
	time_remaining -= delta
	timer_text.text = str(time_remaining)
		
	if (time_remaining <= 0):
		time_remaining = 0
		continueCountdown = false

# Returns a float indicating how long remains on the timer.
func return_normalized_time_remaining() -> float:
	return clamp(time_remaining / time_limit, 0 ,1)
