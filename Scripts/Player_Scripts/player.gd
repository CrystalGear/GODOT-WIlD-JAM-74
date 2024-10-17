extends CharacterBody3D

#exports
@export var walking_speed = 5.0
@export var crouch_walk_speed = 2.5
@export var jump_velocity = 4.5
@export var player_height = 1.7

@onready var camera = $Camera3D
@onready var collision_shape = $CollisionShape3D
@onready var raycast = $RayCast3D
@onready var animation_player = $AnimationPlayer

#vars
var b_is_crouching = false
var current_move_speed = 5.0
var mouse_sensitivity = 0.002
var joystick_sensitivity = 2

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(70), deg_to_rad(70))

func _ready():
	raycast.target_position = Vector3(0, player_height, 0)
	raycast.enabled = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	collision_shape.shape.height = player_height
	

func _physics_process(delta: float) -> void:
	handle_joystick_rotation()
	_apply_gravity(delta)
	_jump()
	crouch()
	_handle_movement()
	move_and_slide()

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
		velocity.x = direction.x * current_move_speed
		velocity.z = direction.z * current_move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_move_speed)
		velocity.z = move_toward(velocity.z, 0, current_move_speed)

func handle_joystick_rotation():
	var rotation_input = Input.get_vector("look_up", "look_down", "look_left", "look_right")
	rotation_degrees.y -= rotation_input.y * joystick_sensitivity
	rotation_degrees.x -= rotation_input.x * joystick_sensitivity

func crouch():
	if not Input.is_action_just_pressed("crouch"):
		return
	if (b_is_crouching == false):
		b_is_crouching = true
		current_move_speed = crouch_walk_speed
		animation_player.play("crouch")
	else:
		if not raycast.is_colliding():
			b_is_crouching = false
			current_move_speed = walking_speed
			animation_player.play_backwards("crouch")
