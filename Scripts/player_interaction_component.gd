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

func pick_up_item() -> void:
	if item:
		if item.is_class("Car_part"):
			$InventoryComponent.pick_up_car_part(item)
			return
		elif item.is_class("Tool"):
			$InventoryComponent.pick_up_tool(item)
			return
		elif item.is_class("Key"):
			$InventoryComponent.pick_up_key()
			return
