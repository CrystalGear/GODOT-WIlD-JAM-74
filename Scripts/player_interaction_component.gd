extends Node3D

var item : Item

func _on_body_entered(body: Node3D) -> void:
	if body is Item:
		item = body
		item.set_outline_visibility(true)


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("interactable"):
		item.set_outline_visibility(false)
		item = null
