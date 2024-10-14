extends Control

func _on_start_button_button_down() -> void:
	LevelManager.show_level_1()

func _on_options_button_button_down() -> void:
	LevelManager.show_options_menu()

func _on_exit_button_button_down() -> void:
	get_tree().quit()
