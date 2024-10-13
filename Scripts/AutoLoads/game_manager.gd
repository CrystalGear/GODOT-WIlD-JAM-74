extends Node

# Constants
var PAUSE_TIME: float = 3.0
var PAUSE_UI:PackedScene = preload("res://Scenes/pause.tscn")
var DISALLOWED_PAUSE_LEVELS = ["SplashScreen", "MainMenu", "OptionsMenu", "WinScreen", "CreditsMenu", "GameOverScreen"]

# Runtime variables
var b_paused:bool = false
var pause_timer
var pause_ui:Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_ui = PAUSE_UI.instantiate() 	# Create an instance of the pause UI
	add_child(pause_ui)  			# Add it to the current scene
	pause_ui.hide()  				# Make sure it starts hidden

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_player_input()
	
func _player_input() -> void:
	
	# Exit early if the scene is null (liek when transitioning)
	if get_tree().current_scene == null:
		return	
		
	# Get the current scene	
	var current_scene = get_tree().current_scene.name
	if current_scene in DISALLOWED_PAUSE_LEVELS:
		return
		
	if(Input.is_action_just_pressed("pause")):
		if(b_paused):
			pause_ui.hide()
			_unpause()
			b_paused = false
		else:
			pause_ui.show()
			_fake_pause()
			b_paused = true

func _fake_pause() -> void:
	
	# Set paused to true
	_toggle_pause(true)
	
	# Start a timer and store it.
	pause_timer = Timer.new()
	add_child(pause_timer)
	pause_timer.wait_time = PAUSE_TIME
	pause_timer.one_shot = true
	pause_timer.start()
	
	pause_timer.connect("timeout", Callable(self, "_unpause"))
	
func _unpause() -> void:
	# Stop the pause timer only if it's still active (not null)
	if pause_timer and pause_timer.is_stopped() == false:
		pause_timer.stop()
	
	# Set paused to false
	_toggle_pause(false)
	
func _toggle_pause(b_new_state:bool) -> void:
		
	# Get any object marked as pausable
	var nodes = get_tree().get_nodes_in_group("pausable")
	
	# Iterate through objects and if they can be pasued set their state
	for node in nodes:
		if node.has_method("toggle_pause"):
			node.toggle_pause(b_new_state)
	
func toggle_pause(b_new_state: bool) -> void:
	# This method is unused and serves as an example of implementation on other objects.
	# Enable the node's _process() function
	set_process(b_new_state)

	# Enable the node's _physics_process() function
	set_physics_process(b_new_state)
