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

func pick_up_car_part(item_to_pickup: Car_part) -> bool:
	##THIS FUNCTION IS EXPLICITLY FOR CAR PARTS
	##USE pick_up_key() for keys
	##USE pick_up_tool() for tools
	
	#check if there is already an item held and if the item attempting to pickup is in correct group
	if get_child_count() == 0 and item_to_pickup.is_in_group("car_parts"):
		item_to_pickup.reparent($ItemSlotTransform, false)
		return true
		
	return false

func pick_up_tool(item_to_pickup: Tool) -> bool:
	##THIS FUNCTION IS EXPLICITLY FOR TOOLS
	##USE pick_up_key() for keys
	##USE pick_up_car_part() for car parts
	
	#check if there is already an item held and if the item attempting to pickup is in correct group
	if get_child_count() == 0 and item_to_pickup.is_in_group("tool"):
		item_to_pickup.reparent($ItemSlotTransform, false)
		return true
		
	return false

func pick_up_key() -> void:
	##THIS FUNCTION IS EXPLICITLY FOR TOOLS
	##USE pick_up_tool() for tools
	##USE pick_up_car_part() for car parts
	pass

func throw_held_item(throwing_power: float) -> void:
	pass
