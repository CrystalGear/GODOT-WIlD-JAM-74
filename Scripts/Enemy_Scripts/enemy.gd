extends CharacterBody3D

@export var speed: float = 3.0
var player: CharacterBody3D = null

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

func _ready():
	player = get_tree().root.get_node("BlockoutLevel/Player")
	if player:
		nav_agent.target_position = player.global_transform.origin

func _process(delta):
	if player:
		nav_agent.target_position = player.global_transform.origin

		if not nav_agent.is_navigation_finished():
			var next_position = nav_agent.get_next_path_position()
			var direction = (next_position - global_transform.origin).normalized()
			velocity = direction * speed

		move_and_slide()
