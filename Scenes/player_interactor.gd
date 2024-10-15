extends Interactor

#get reference to player its attached too
@export var player: CharacterBody3D

var closest_item: Interactable

func _ready() -> void:
	controller = player
	
	
func _physics_process(delta: float) -> void:
	var new_closest: Interactable = get_closest_iteractable()
	
	if new_closest != closest_item:
		if is_instance_valid(closest_item):
			unfocus(closest_item)
		if new_closest:
			focus(new_closest)
			
		closest_item = new_closest
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("primary_action"):
		if closest_item:
			interact(closest_item)
			
func _on_area_exited(area: Interactable) -> void:
	if closest_item == area:
		unfocus(area)
	
