class_name Root
extends Node

@export_file ("*.tscn") var start_scene: String

var current_scene: Node

func _enter_tree() -> void:
	Global.root = self
	
func _ready() -> void:
	load_scene(start_scene)



func load_scene(next_scene: String):
	var new_scene = load(next_scene)
	if next_scene:
		var loaded_scene: Node = new_scene.instantiate()
		if loaded_scene:
			Global.player.enabled = false
			if current_scene:
				current_scene.queue_free()
			current_scene = loaded_scene
			add_child(loaded_scene)
			_on_scene_changed()

func _on_scene_changed():
	var player_start: Node2D = current_scene.find_child("player_start")
	if Global.player:
		Global.player.global_position = player_start.global_position
		Global.player.visible = true
		Global.player.set_physics_process(true)
		Global.player.set_process(true)
		Global.player.set_process_unhandled_input(true)
		Global.player.camera.enabled = true
		Global.player.camera.reset_smoothing()
	else:
		Global.player.enabled = false
		Global.player.set_physics_process(false)
		Global.player.set_process(false)
		Global.player.set_process_unhandled_input(false)
		Global.player.visible = false
		Global.player.camera.enabled = false
