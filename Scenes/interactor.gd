extends Area3D


class_name Interactor

var controller: Node3D


#signals for the interactable items
func interact(interactable:Interactable) -> void:
	interactable.interacted.emit(self)
	
func focus(interactable: Interactable) -> void:
	interactable.focused.emit(self)

func unfocus(interactable: Interactable) -> void:
	interactable.unfocused.emit(self)


#find the closest interactable incase there is multiple near, returns null if none
func get_closest_iteractable() -> Interactable:
	var list: Array[Area3D] = get_overlapping_areas()
	var distance: float
	var closest_distance: float = INF
	var closest: Interactable = null
	
	#goes through the list to find the closest interactable
	for interactable in list:
		distance = interactable.global_position.distance_to(global_position)
		
		if distance < closest_distance:
			closest = interactable as Interactable
			closest_distance = distance
			

	return closest
