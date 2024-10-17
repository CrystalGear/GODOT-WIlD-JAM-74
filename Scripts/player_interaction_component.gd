extends Node3D

var item : Item
@onready var InventoryComponent = $InventoryComponent

func _on_body_entered(body: Node3D) -> void:
	if body is Item:
		item = body
		item.set_outline_visibility(true)


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("interactable") and item:
		item.set_outline_visibility(false)
		item = null

func _pick_up_item() -> void:
	if item:
		if InventoryComponent.pick_up_car_part(item):
			item.set_outline_visibility(false)
			print("Car part picked up")
			item = null
			return
		elif InventoryComponent.pick_up_tool(item):
			item = null
			return
		elif InventoryComponent.pick_up_key():
			item = null
			return

func interact_with_item() -> void:
	if not item:
		return
	
	if item.is_class("Interactable_object"):
		print("use item")
		return
	else:
		_pick_up_item()
		
func drop_item():
	InventoryComponent.drop()
