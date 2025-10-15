extends Node

var music_player: AudioStreamPlayer

func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	music_player.bus = &"Music"
	add_child(music_player)

func play_music(music_stream: AudioStream) -> void:
	if music_player.stream != music_stream:
		music_player.stream = music_stream
		music_player.play()
