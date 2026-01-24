extends Node

@export_file ("*.tscn") var level_select_scene: String

@onready var start_button: Button = $ColorRect/Start_Button
@onready var credits_button: Button = $CreditsBtn

var testLevel = "res://Scenes/Rooms/feature_test_level.tscn"


func _on_start_button_pressed():
	#Global.root.load_scene(level_select_scene)
	get_tree().change_scene_to_file(level_select_scene)


func _on_test_level_pressed() -> void:
	#Global.root.load_scene(testLevel)
	get_tree().change_scene_to_file(testLevel)


func _on_credits_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Rooms/credits.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		if event.pressed:
			match event.button_index:
				JOY_BUTTON_A, JOY_BUTTON_START:
					start_button.pressed.emit()
				JOY_BUTTON_B, JOY_BUTTON_BACK:
					credits_button.pressed.emit()


func _on_touch_start_button_pressed() -> void:
	start_button.pressed.emit()


func _on_touch_credit_button_pressed() -> void:
	credits_button.pressed.emit()
