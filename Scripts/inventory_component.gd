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


var player_node

@export var drop_launch_force : float = 5
@export var throw_launch_force : float = 20


var KeysQuantity : int
var held_item : Item

func pick_up_car_part(item_to_pickup: Node3D) -> bool:
	##THIS FUNCTION IS EXPLICITLY FOR CAR PARTS
	##USE pick_up_key() for keys
	##USE pick_up_tool() for tools
	
	#check if there is already an item held and if the item attempting to pickup is in correct group
	if $ItemSlotTransform.get_child_count() == 0 and item_to_pickup is Car_part:
		held_item = item_to_pickup
		held_item.collision_layer = 0
		held_item.collision_mask = 0
		player_node.block_flashlight = true
		
		((held_item as Node3D) as RigidBody3D).freeze = true
		held_item.reparent($ItemSlotTransform, true)
		held_item.transform = $ItemSlotTransform.transform
		held_item.set_physics_process(false)
		return true
		
	return false

func pick_up_tool(item_to_pickup: Node3D) -> bool:
	##THIS FUNCTION IS EXPLICITLY FOR TOOLS
	##USE pick_up_key() for keys
	##USE pick_up_car_part() for car parts
	
	#check if there is already an item held and if the item attempting to pickup is in correct group
	if $ItemSlotTransform.get_child_count() == 0 and item_to_pickup is Tool :
		held_item = item_to_pickup
		held_item.collision_layer = 0
		held_item.collision_mask = 0
		
		((held_item as Node3D) as RigidBody3D).freeze = true
		held_item.reparent($ItemSlotTransform, true)
		held_item.transform = $ItemSlotTransform.transform
		held_item.set_physics_process(false)
		return true
		
	return false

func pick_up_key() -> bool:
	KeysQuantity += 1
	return true

func throw_held_item() -> void:
	if held_item != null:
		#add collision back to item
		held_item.collision_layer = 2
		held_item.collision_mask = 1
		
		#move the item to the camera position to prevent throwing out of bounds
		held_item.global_position = player_node.camera.global_position
		
		#reparent to the tree so its not attached to the player anymore
		held_item.reparent(get_tree().current_scene, true)
		
		#turn physics sim back on
		((held_item as Node3D) as RigidBody3D).freeze = false
		held_item.set_physics_process(true)
		
		#throw
		held_item.apply_impulse(-player_node.camera.global_transform.basis[2]*(held_item.mass*throw_launch_force))
		player_node.block_flashlight = false
		
		#clear the held item variable
		held_item = null



func drop_held_item() -> Item:
	if held_item != null:
		var temp_item = held_item
		#add collision back to item
		held_item.collision_layer = 2
		held_item.collision_mask = 1
		
		#move the item to the camera position to prevent throwing out of bounds
		held_item.global_position = player_node.camera.global_position
		
		#reparent to the tree so its not attached to the player anymore
		held_item.reparent(get_tree().current_scene, true)
		
		#turn physics sim back on
		((held_item as Node3D) as RigidBody3D).freeze = false
		held_item.set_physics_process(true)
		
		#throw
		held_item.apply_impulse(-player_node.camera.global_transform.basis[2]*(held_item.mass*drop_launch_force))
		player_node.block_flashlight = false
		#clear the held item variable
		held_item = null
		return temp_item
	return null
		
	
	
	
