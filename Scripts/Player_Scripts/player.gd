extends CharacterBody3D


@export var speed = 5.0
@export var jump_velocity = 4.5

@export var flash_light_on = false
@export var light_charge = 100
@export var light_fade_threshold = 40
@onready var flash_light: SpotLight3D = $Camera3D/FlashlightHand/SpotLight3D

var mouse_sensitivity = 0.002

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
		
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_jump()
	_handle_movement()
	move_and_slide()
	
	_flash_light(delta)
	

func _flash_light(delta: float):
	# Sticking flashlight code here for now
	# Stops charging down once charge is at 0
	if (light_charge > 0 && flash_light_on == true):
		light_charge -= delta
	
	# Checks if light charge is under the fading threshold, default 40%
	# then starts fading the flashlight
	if flash_light_on:
		if (light_charge < light_fade_threshold):
			if(light_charge < 0):
				light_charge = 0
			flash_light.light_energy = (light_charge / light_fade_threshold)
		else:
			flash_light.light_energy = 1
	else:
		flash_light.light_energy = 0
	
	if (Input.is_action_just_pressed("secondary_action")):
		flash_light_on = not flash_light_on

func _flash_light_charge(new_charge: float) -> void:
	if (new_charge > 100):
		new_charge = 100
	elif (new_charge < 0):
		new_charge = 0
	light_charge = new_charge

# Add the gravity.
func _apply_gravity(delta: float):
	if not is_on_floor():
		velocity += get_gravity() * delta

# Handle jump.
func _jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

# Get the input direction and handle the movement/deceleration.
func _handle_movement():
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
