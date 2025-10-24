extends Node2D

@export var shoot_sound: AudioStreamPlayer
@export var land_sound: AudioStreamPlayer


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Action"):
		shoot_sound.play()
