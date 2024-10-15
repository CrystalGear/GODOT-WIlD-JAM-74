extends CharacterBody3D




@onready var raycast = $Camera3D/Raycast
@onready var hand = $Camera3D/Hand

@export var speed = 5.0
@export var jump_velocity = 4.5
@export var pull = 5

var mouse_sensitivity = 0.002

var picked_object


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
	_grab()
	_carry()

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


		

func _grab():
	if Input.is_action_just_pressed("primary_action"):
		if picked_object == null:
			print("grab input pressed")
		
			_pick_object()
		elif picked_object != null:
			_drop()
		
		
		
		

func _pick_object():
	var collider = raycast.get_collider()
	print(collider)
	
	if collider != null and collider is RigidBody3D:
		picked_object = collider
		
		print("picked object up, that object is-")
		print(picked_object)


func _carry():
	if picked_object != null:
		var start = picked_object.global_transform.origin
		var hand_pos = hand.global_transform.origin
		picked_object.set_linear_velocity((hand_pos-start) * pull)
		
		print("carrying")


func _drop():
	if picked_object != null:
		picked_object = null
		
