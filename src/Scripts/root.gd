class_name Root
extends Node

@export var start_scene: PackedScene

@onready var player: Player = $Player

var current_scene: Node


func _ready() -> void:
	Global.root = self
	load_scene(start_scene)

func load_scene(next_scene: PackedScene):
	if next_scene:
		var loaded_scene: Node = next_scene.instantiate()
		if loaded_scene:
			if current_scene:
				current_scene.queue_free()
			current_scene = loaded_scene
			add_child(loaded_scene)
			_on_scene_changed()

func _on_scene_changed():
	var player_start: Node2D = current_scene.find_child("player_start")
	if player_start:
		player.position = player_start.position
		player.visible = true
		player.set_physics_process(true)
		player.set_process(true)
		player.set_process_unhandled_input(true)
		#%Player.camera.enabled = true
		#%Player.camera.reset_smoothing()
	else:
		player.set_physics_process(false)
		player.set_process(false)
		player.set_process_unhandled_input(false)
		player.visible = false
		#%Player.camera.enabled = false
