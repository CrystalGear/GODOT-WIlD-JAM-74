extends Node
##This inventory system works with two major categories of items
##
##	keys and holdable items:
##
##		keys are simple, they are a logical items that flick a bool in the collectable manager
##	
##		holdable items, there are two categories - car parts and tools:
##			tools: one handed items, flashlight is useable while holding
##			car parts: two handed, the flashlight isnt usable while holding
##		
##		you can only hold one holdable item at once

var KeysQuantity : int
var held_item : Item

func pick_up_car_part(item_to_pickup: Car_part) -> bool:
	##THIS FUNCTION IS EXPLICITLY FOR CAR PARTS
	##USE pick_up_key() for keys
	##USE pick_up_tool() for tools
	
	#check if there is already an item held and if the item attempting to pickup is in correct group
	if $ItemSlotTransform.get_child_count() == 0 and item_to_pickup is Car_part:
		held_item = item_to_pickup
		held_item.collision_layer = 0
		held_item.collision_mask = 0
		print("item conditions true")
		return true
		
	return false

func pick_up_tool(item_to_pickup: Tool) -> bool:
	##THIS FUNCTION IS EXPLICITLY FOR TOOLS
	##USE pick_up_key() for keys
	##USE pick_up_car_part() for car parts
	
	#check if there is already an item held and if the item attempting to pickup is in correct group
	if $ItemSlotTransform.get_child_count() == 0 and item_to_pickup is Tool :
		held_item = item_to_pickup
		return true
		
	return false

func pick_up_key() -> void:
	KeysQuantity += 1

func throw_held_item(throwing_power: float) -> void:
	pass
	
func carry(player: Player):
	var player_node = player
	if held_item != null:
		var start = held_item.global_transform.origin
		var hand_pos = $ItemSlotTransform.global_transform.origin
		var new_velocity = (hand_pos-start) * player_node.pull
		var smooth_velocity = lerp(held_item.linear_velocity, new_velocity, 0.3)
		held_item.set_linear_velocity(smooth_velocity)
		held_item.global_transform.basis = player.camera.global_transform.basis
		 
		##Get the player node (does not work in ready or @onready) check distance to picked object and drop if too far away.
		if player_node != null:
			var player_pos = player_node.global_transform.origin
			var max_distance = 4.5
			var distance_to_player = start.distance_to(player_pos)
			if distance_to_player > max_distance:
				drop()

func drop():
	if held_item != null:
		held_item.collision_layer = 1
		held_item.collision_mask = 1
		print("dropped item")
		held_item = null
