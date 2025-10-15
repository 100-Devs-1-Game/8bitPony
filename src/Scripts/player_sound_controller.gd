extends Node2D

@export var shoot_sound: AudioStreamPlayer
@export var land_sound: AudioStreamPlayer


func _input(_event: InputEvent):
	if Input.is_action_just_pressed("Action"):
		shoot_sound.play()
