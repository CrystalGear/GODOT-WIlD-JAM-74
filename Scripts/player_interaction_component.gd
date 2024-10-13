extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact_with_item() -> bool:
## item interaction function.
## returns true if interaction successful
## returns false if interaction failed

	if not $RayCast3D.is_colliding():
		return false
	else:
		var target = $RayCast3D.get_collider()
		
		return true
		
		
