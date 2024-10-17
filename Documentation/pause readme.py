# How to add objects to the list of objects that stop when the player pauses the game

# First add the object to the "pausable" group
# The object also needs a method "func toggle_pause(b_new_state: bool) -> void:" which toggles the paused state

# How this method works will vary by object types.

# Heres an example for rigidbody3D (tested)

func toggle_pause(b_new_state: bool) -> void:
	sleeping = b_new_state

# Also another example for nodes (untested)

func toggle_pause(b_new_state: bool) -> void:
	# This method is unused and serves as an example of implementation on other objects.
	# Enable the node's _process() function
	set_process(b_new_state)

	# Enable the node's _physics_process() function
	set_physics_process(b_new_state)
