class_name Enemy extends CharacterBody3D

signal direction_changed()

@export var speed: float = 3.0
var player: CharacterBody3D = null

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

func _ready():
	player = get_tree().root.get_node("BlockoutLevel/Player")
	if player:
		set_target_to_player()

func _process(delta):
	_check_collisions()
	if player:
		set_target_to_player()
		move_towards_target()

func set_target_to_player():
	nav_agent.target_position = player.global_transform.origin

func move_towards_target():
	if not nav_agent.is_navigation_finished():
		var next_position = nav_agent.get_next_path_position()
		var direction = (next_position - global_transform.origin).normalized()
		velocity = direction * speed
		move_and_slide()

func _check_collisions():
	var overlaps = $VisionArea.get_overlapping_bodies()
	if overlaps.size() > 0:
		for overlap in overlaps:
			if overlap.name == "Player":
				var playerPosition = overlap.global_transform.origin
				$VisionRaycast.force_raycast_update()
				
				if $VisionRaycast.is_colliding():
					var collider = $VisionRaycast.get_collider()
					
					if collider.name == "Player":
						$VisionRaycast.debug_shape_custom_color = Color(174,0,0)
						print ("I SEE YOU")
					else:
						$VisionRaycast.debug_shape_custom_color = Color(0, 255,0)
						print ("I DONT SEE YOU")
