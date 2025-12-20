extends Node

@export_file ("*.tscn") var level_select_scene: String

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.room_tracker = Global.Room.MainMenu

func _on_start_button_pressed():
	Global.root.load_scene(level_select_scene)
