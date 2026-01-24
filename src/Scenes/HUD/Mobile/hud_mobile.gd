extends Control


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		visible = true
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	elif event is InputEventKey:
		visible = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventJoypadButton:
		visible = false
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
