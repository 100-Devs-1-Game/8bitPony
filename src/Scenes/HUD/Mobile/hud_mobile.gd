extends Control


func _ready() -> void:
	_handle_joy_connection_changed()
	Input.joy_connection_changed.connect(_handle_joy_connection_changed)

func _handle_joy_connection_changed():
	visible = Input.get_connected_joypads().is_empty()
