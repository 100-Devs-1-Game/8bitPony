extends Node

@export var level_select_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.room_tracker = Global.Room.MainMenu

func _on_start_button_pressed():
	Global.root.load_scene(level_select_scene)
