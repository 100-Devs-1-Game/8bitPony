extends ColorRect

@onready var main_menu_button: Button = $MainMenuButton


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Rooms/main_menu.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		if event.pressed:
			match event.button_index:
				JOY_BUTTON_A, JOY_BUTTON_B, JOY_BUTTON_START:
					main_menu_button.pressed.emit()

func _on_touch_main_menu_button_pressed() -> void:
	main_menu_button.pressed.emit()
