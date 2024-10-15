extends Area3D

class_name Interactable


#Pings when hit by the interactor
signal focused(interactor: Interactor)

#Pings when the interactor stops looking at me
signal unfocused(interactor: Interactor)

#Pings when interacted with
signal interacted(interactor: Interactor)


func _on_focused(interactor):
	pass


func _on_interacted(interactor):
	print("hellothere") 


func _on_unfocused(interactor):
	pass # Replace with function body.
