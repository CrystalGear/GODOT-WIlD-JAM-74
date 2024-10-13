extends CharacterBody3D


var current_move_speed = 5.0
@export var walking_speed = 5.0
@export var crouch_walk_speed = 2.5
@export var jump_velocity = 4.5
@export var player_height = 1.7
@export var standing_camera_height = 0.677
@export var crouched_camera_height = 0.255
var b_is_crouching = false
var mouse_sensitivity = 0.002
var joystick_sensitivity = 2

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$CollisionShape3D.shape.height = player_height
	print($CollisionShape3D.shape.height)

func _physics_process(delta: float) -> void:
	handle_joystick_rotation()
	apply_gravity(delta)
	jump()
	crouch(delta)
	handle_movement()
	move_and_slide()

# Add the gravity.
func apply_gravity(delta: float):
	if not is_on_floor():
		velocity += get_gravity() * delta

# Handle jump.
func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

# Get the input direction and handle the movement/deceleration.
func handle_movement():
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * current_move_speed
		velocity.z = direction.z * current_move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_move_speed)
		velocity.z = move_toward(velocity.z, 0, current_move_speed)

func handle_joystick_rotation():
	var rotation_input = Input.get_vector("look_up", "look_down", "look_left", "look_right")
	rotation_degrees.y -= rotation_input.y * joystick_sensitivity
	rotation_degrees.x -= rotation_input.x * joystick_sensitivity

func crouch(delta: float):
	if Input.is_action_just_pressed("crouch") && (b_is_crouching == false):
		b_is_crouching = true
		current_move_speed = crouch_walk_speed
		$AnimationPlayer.play("crouch")
		print($CollisionShape3D.shape.height)
	elif Input.is_action_just_pressed("crouch") && (b_is_crouching == true):
		b_is_crouching = false
		current_move_speed = walking_speed
		$AnimationPlayer.play_backwards("crouch")
		print($CollisionShape3D.shape.height)
