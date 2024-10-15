extends CharacterBody3D




@export var speed = 5.0
@export var jump_velocity = 4.5
@export var pull = 12
@export var throw_strength = 10

@onready var camera_node: Camera3D = $Camera3D
@onready var raycast: RayCast3D = $Camera3D/Raycast
@onready var hand: Node3D = $Camera3D/Hand


var mouse_sensitivity = 0.002
var picked_object
var player_node

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
	grab()
	carry()
	throw()

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



##Pick up an object or drop an object you're carrying on input.
func grab():
	if Input.is_action_just_pressed("primary_action"):
		if picked_object == null:
			pick_object()
		elif picked_object != null:
			drop()


##Use the raycast to target an object and add it to the picked object variable.
func pick_object():
	var collider = raycast.get_collider()
	
	if collider != null and collider is RigidBody3D:
		picked_object = collider
		


##Move the picked_object to the players hand and bind its rotation to the camera.
func carry():
	if picked_object != null:
		var start = picked_object.global_transform.origin
		var hand_pos = hand.global_transform.origin
		var new_velocity = (hand_pos-start) * pull
		var smooth_velocity = lerp(picked_object.linear_velocity, new_velocity, 0.3)
		picked_object.set_linear_velocity(smooth_velocity)
		picked_object.global_transform.basis = camera_node.global_transform.basis
		 
		##Get the player node (does not work in ready or @onready) check distance to picked object and drop if too far away.
		var player_node = get_node("/root/BlockoutLevel/Player") 
		if player_node != null:
			var player_pos = player_node.global_transform.origin
			var max_distance = 4.5
			var distance_to_player = start.distance_to(player_pos)
			if distance_to_player > max_distance:
				drop()


##Drop a picked up object.
func drop():
	if picked_object != null:
		picked_object = null

##Add impulse to a picked up object and clear the var.
func throw():
	if Input.is_action_just_pressed("secondary_action"):
		if picked_object != null:
			var throw_direction = (hand.global_transform.basis.z * -1).normalized()
			picked_object.apply_central_impulse(throw_direction * throw_strength)
			picked_object = null
