extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_button_down() -> void:
	LevelManager.show_level_1()


func _on_options_button_button_down() -> void:
	LevelManager.show_options_menu()


func _on_exit_button_button_down() -> void:
	get_tree().quit()
