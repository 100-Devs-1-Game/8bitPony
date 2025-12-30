extends Node

@export_file ("*.tscn") var level_select_scene: String
var testLevel = "res://Scenes/Rooms/feature_test_level.tscn"


func _on_start_button_pressed():
	#Global.root.load_scene(level_select_scene)
	get_tree().change_scene_to_file(level_select_scene)


func _on_test_level_pressed() -> void:
	#Global.root.load_scene(testLevel)
	get_tree().change_scene_to_file(testLevel)


func _on_credits_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Rooms/credits.tscn")
