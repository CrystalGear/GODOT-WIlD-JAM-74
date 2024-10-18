extends CharacterBody3D

enum EnemyState { PATROL, CHASE }

@export var speed: float = 3.0
@export var patrol_speed: float = 1.5
@export var chase_speed: float = 3.0
@export var detection_radius: float = 10.0

@export var patrol_min_bounds: Vector3 = Vector3(-1000, 0, -1000)
@export var patrol_max_bounds: Vector3 = Vector3(1000, 0, 1000)

var player: CharacterBody3D = null
var state: EnemyState = EnemyState.PATROL

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var nav_region: NavigationRegion3D = get_node("../NavigationRegion3D")

func _ready():
	# Initializes the enemy and sets the player reference.
	player = get_tree().root.get_node("BlockoutLevel/Player")
	if player:
		call_deferred("patrol")

func _process(delta):
	# Handles state transitions and updates behavior based on the current state.
	match state:
		EnemyState.PATROL:
			patrol_behavior()
		EnemyState.CHASE:
			chase_behavior()
	check_for_player()

func patrol():
	# Sets a random patrol point for the enemy to move towards.
	var random_position = await get_random_patrol_point()
	nav_agent.target_position = random_position
	state = EnemyState.PATROL
	speed = patrol_speed

func chase():
	# Switches the enemy state to CHASE.
	state = EnemyState.CHASE
	speed = chase_speed

func check_for_player():
	# Checks if the player is within detection radius and transitions state accordingly.
	if player and global_transform.origin.distance_to(player.global_transform.origin) <= detection_radius:
		chase()
	else:
		if state == EnemyState.CHASE and global_transform.origin.distance_to(player.global_transform.origin) > detection_radius:
			patrol()

func patrol_behavior():
	# Manages the patrol behavior of the enemy.
	if nav_agent.is_navigation_finished():
		patrol()
	else:
		move_towards_target()

func chase_behavior():
	# Manages the chase behavior of the enemy.
	if player:
		set_target_to_player()
		move_towards_target()

func set_target_to_player():
	# Sets the target position of the navigation agent to the player's position.
	nav_agent.target_position = player.global_transform.origin

func move_towards_target():
	# Moves the enemy towards the target position set by the navigation agent.
	if not nav_agent.is_navigation_finished():
		var next_position = nav_agent.get_next_path_position()
		var direction = (next_position - global_transform.origin).normalized()
		velocity = direction * speed
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
