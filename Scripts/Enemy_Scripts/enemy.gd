class_name Enemy extends CharacterBody3D

# Three states, each of which are controlled by their own respective functions.
enum EnemyState { PATROL, CHASE, SEARCH }

@export var base_movement_speed: float = 3.0
@export var patrol_speed: float = 1.5
@export var chase_speed: float = 3.0
@export var detection_radius: float = 10.0
@export var debug_mode: bool = false

@export var patrol_min_bounds: Vector3 = Vector3(-50, -3, -15)
@export var patrol_max_bounds: Vector3 = Vector3(10, 9, 20)

var player: CharacterBody3D = null
var state: EnemyState = EnemyState.PATROL
var b_can_see_player: bool = false

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var nav_region: NavigationRegion3D = get_node("../NavigationRegion3D")
@onready var raycast: RayCast3D = $VisionRaycast

func _ready() -> void:
	# Initializes the enemy and sets the player reference.
	player = get_tree().root.get_node("BlockoutLevel/Player")
	if player:
		call_deferred("patrol") # Required because it errors if done before the navmesh is fully mapped at runtime

func handle_debug_mode() -> void:
	# Handles state transitions and updates behavior based on the current state.
	# debug_mode: disables detection of player and increases speed to allow observation of random pathing. Leaving in because this is the scene that will likely be tweaked most while designing over the weekend
	if debug_mode:
		patrol_speed = 10
		base_movement_speed = patrol_speed
		match state:
			EnemyState.PATROL:
				patrol_behavior()
	else:
		match state:
			EnemyState.PATROL:
				patrol_behavior()
			EnemyState.CHASE:
				chase_behavior()
			EnemyState.SEARCH:
				search_behavior()
		if b_can_see_player:
			state = EnemyState.CHASE
		elif state == EnemyState.CHASE and not b_can_see_player:
			state = EnemyState.SEARCH
		elif state == EnemyState.SEARCH and not b_can_see_player:
			state = EnemyState.PATROL

func rotate_enemy_movement() -> void:
	look_at(global_transform.origin - velocity)

func _process(delta) -> void:
	handle_debug_mode()
	_check_collisions()
	rotate_enemy_movement()
	#print("I am currently in the ", state)

func patrol() -> void:
	# Sets a random patrol point for the enemy to move towards.
	var random_position = await get_random_patrol_point()
	nav_agent.target_position = random_position
	state = EnemyState.PATROL
	base_movement_speed = patrol_speed

func chase() -> void:
	# Switches the enemy state to CHASE.
	state = EnemyState.CHASE
	base_movement_speed = chase_speed

func patrol_behavior() -> void:
	# Manages the patrol behavior of the enemy.
	if nav_agent.is_navigation_finished():
		patrol()
	else:
		move_towards_target()

func chase_behavior() -> void:
	# Manages the chase behavior of the enemy.
	if player:
		set_target_to_player()
		move_towards_target()
	if not b_can_see_player:
		state = EnemyState.SEARCH
		nav_agent.target_position = player.global_transform.origin
		
func search_behavior() -> void:
	# The enemy looks around for a short period before resuming patrol.
	if nav_agent.is_navigation_finished():
		patrol()
	else:
		move_towards_target()
		
func set_target_to_player() -> void:
	# Sets the target position of the navigation agent to the player's position.
	nav_agent.target_position = player.global_transform.origin

func move_towards_target() -> void:
	# Moves the enemy towards the target position set by the navigation agent.
	if nav_agent.is_navigation_finished():
		return
	var next_position = nav_agent.get_next_path_position()
	var direction = (next_position - global_transform.origin).normalized()
	velocity = direction * base_movement_speed
	move_and_slide()

func get_random_patrol_point() -> Vector3:
	# Generates a random point within the patrol area and validates it using NavigationServer3D.
	await get_tree().physics_frame
	var random_position = Vector3(
		randf_range(patrol_min_bounds.x, patrol_max_bounds.x),
		patrol_min_bounds.y,
		randf_range(patrol_min_bounds.z, patrol_max_bounds.z)
	)
	var map_rid = nav_region.get_navigation_map()
	var nearest_point = NavigationServer3D.map_get_closest_point(map_rid, random_position)
	return nearest_point

func _check_collisions() -> void:
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider.name == "Player": # leaving the following debug colours in as we test over the weekend, debug ray only visible if you set Debug -> Visible Collision Shapes setting to true
			raycast.debug_shape_custom_color = Color(174,0,0)
			b_can_see_player = true
		else:
			raycast.debug_shape_custom_color = Color(0, 255,0)
			b_can_see_player = false
