extends Node3D

func _on_killbox_area_3d_body_entered(body: Node3D) -> void:
	print(body.name)
	body.position = position
