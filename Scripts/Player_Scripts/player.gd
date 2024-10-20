class_name Player extends CharacterBody3D

#exports
@export var walking_speed:float = 5.0
@export var crouch_walk_speed = 2.5
@export var jump_velocity:float = 4.5
@export var step_timer = 550

@export var flash_light_on = false
var block_flashlight = false
@export var light_charge = 100
@export var light_fade_threshold = 40
@onready var flash_light: SpotLight3D = $Camera3D/FlashlightHand/SpotLight3D
@onready var flash_light_sound: AudioStreamPlayer3D = $Camera3D/FlashlightHand/FlashLightSound
@onready var flash_light_turn_on: AudioStreamPlayer3D = $Camera3D/FlashlightHand/FlashLightTurnOn
@onready var step_sound: AudioStreamPlayer3D = $StepSound


@export var player_height = 1.9
@export var camera_shake_time = 1
@export var camera_shake_intensity = 0.4

@export var pull = 12
@export var enemy: Enemy


@export var atticSpawner: Node3D
@export var basementSpawner: Node3D

@export var repair_sound: AudioStream


@onready var camera = $Camera3D
@onready var collision_shape = $CollisionShape3D
@onready var raycast = $RayCast3D
@onready var animation_player = $AnimationPlayer
@onready var interaction_component = $Camera3D/PlayerInteractionComponent
@onready var interaction_cast: RayCast3D = $InteractionCast

#vars
var b_is_crouching = false
var current_move_speed = 5.0
var mouse_sensitivity:float:
	get:
		# Shifting the mouse sensitivity stored by 200 due to the low precision of the slider.
		return OptionsManager.mouse_sensitivity / 200
	set(value):
		OptionsManager.Set_Mouse_Sensitivity(value * 200)
var joystick_sensitivity = 2
var input_dir: Vector2
var b_is_stunned: bool = false


func _input(event) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(70), deg_to_rad(70))

func _ready() -> void:
	raycast.target_position = Vector3(0, player_height, 0)
	raycast.enabled = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	collision_shape.shape.height = player_height
	
	#Attempt to place the music player as a child of the palyer
	AudioManager.attach_to_player()

func _physics_process(delta: float) -> void:
	handle_joystick_rotation()
	_apply_gravity(delta)
	_jump()
	crouch()
	_handle_movement()
	move_and_slide()
	interact_with_object()
	drop_held_object()
	throw_held_object()
	interaction_component.InventoryComponent.player_node = self
	_flash_light(delta)
	_step_handler()
	
	emit_sound_collider()
	#print("Player's location: " + str(global_transform.origin))

func emit_sound_collider() -> void:
	if input_dir != Vector2.ZERO and b_is_crouching == false:
		if $WalkSoundShapeCast.is_colliding():
			var collider = $WalkSoundShapeCast.get_collider(0)
			if collider is Enemy:
				enemy.chase()
	elif input_dir != Vector2.ZERO and b_is_crouching == true:
		if $CrouchSoundShapeCast.is_colliding():
			var collider = $CrouchSoundShapeCast.get_collider(0)
			if collider is Enemy:
				enemy.chase()

func _flash_light(delta: float):
	# Sticking flashlight code here for now
	# Stops charging down once charge is at 0
	if (light_charge > 0 && flash_light_on == true):
		light_charge -= delta
	
	# Checks if light charge is under the fading threshold, default 40%
	# then starts fading the flashlight
	if flash_light_on and not block_flashlight:
		if (light_charge < light_fade_threshold):
			if(light_charge < 0):
				light_charge = 0
				flash_light_sound.volume_db = -999
			flash_light.light_energy = (light_charge / light_fade_threshold)
			flash_light_sound.volume_db = -15 + ((flash_light.light_energy * 20) - 20)
		else:
			flash_light.light_energy = 1
			flash_light_sound.volume_db = -15
	else:
		flash_light.light_energy = 0
		flash_light_sound.volume_db = -999
	
	if (Input.is_action_just_pressed("middle_mouse")):
		flash_light_on = not flash_light_on
		flash_light_turn_on.play()

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
func _jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

# Get the input direction and handle the movement/deceleration.
func _handle_movement() -> void:

	if b_is_stunned:
		velocity = Vector3.ZERO
	input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * current_move_speed
		velocity.z = direction.z * current_move_speed
		var absolute_velocity = velocity.abs()
		step_timer -= ((absolute_velocity.x + absolute_velocity.z) / 2 * current_move_speed)
	else:
		input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * current_move_speed
			velocity.z = direction.z * current_move_speed
		else:
			velocity.x = move_toward(velocity.x, 0, current_move_speed)
			velocity.z = move_toward(velocity.z, 0, current_move_speed)

func _step_handler() -> void:
	if (step_timer <= 0):
		step_sound.play()
		step_timer = 550

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
			
func interact_with_object():
	if Input.is_action_just_pressed("primary_action"):
		interaction_component.interact_with_item()
		if interaction_cast.is_colliding():
			var other = interaction_cast.get_collider()
			if other is Openable:
				print("opening")
				other.use()
			if other is Repairable:
				if other.repair($Camera3D/PlayerInteractionComponent/InventoryComponent/ItemSlotTransform.get_child(0)):
					animation_player.play("repair")
					AudioManager.play_clip(repair_sound)
				

func drop_held_object():
	if Input.is_action_just_pressed("secondary_action"):
		interaction_component.drop_item()
		
		
func throw_held_object():
	if Input.is_action_just_pressed("throw"):
		interaction_component.throw_item()

func flip_stun() -> void:
	print("Calling FLIP_STUN")
	if $StunTimer.time_left > 0:
		print("FLIP STUN ABORTED - ALREADY RUNNING")
		return
	b_is_stunned = !b_is_stunned
	print(b_is_stunned)
	$Camera3D.camera_shake(camera_shake_time, camera_shake_intensity)
	$StunTimer.start()
	enemy.teleport_to_base()
	force_drop()

func reset_stun() -> void:
	if !b_is_stunned:
		return
	b_is_stunned = !b_is_stunned

func _on_stun_timer_timeout() -> void:
	reset_stun()

func force_drop():
	var temp_item = interaction_component.drop_item()
	if temp_item:
		print(temp_item.name)
		if self.transform.origin.y > 0:
			temp_item.transform.origin = basementSpawner.transform.origin
		else:
			temp_item.transform.origin = atticSpawner.transform.origin
