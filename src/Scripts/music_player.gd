class_name MusicPlayer
extends Node

@export var music_stream: AudioStream

func _ready() -> void:
	Music.play_music(music_stream)
