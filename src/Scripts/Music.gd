extends Node


@onready var music_player: AudioStreamPlayer = $LevelMusic

const LEVEL_6_CLOUD = preload("uid://nh76qkjg5xlc")
const LEVEL_3_CAVE = preload("uid://b3b3pml3cgxns")
const LEVEL_7_BOSS = preload("uid://by3c1cppv38ih")
const LEVEL_4_LIBRARY = preload("uid://xrpiot3ik0uf")
const MENU_CREDITS = preload("uid://duiuksi3cy4p7")
const LEVEL_5_SUGAR = preload("uid://spy86lhoemrr")
const LEVEL_1_TIMBER = preload("uid://73dytvwxgpnt")


var level_music = [MENU_CREDITS, LEVEL_1_TIMBER, LEVEL_1_TIMBER, LEVEL_3_CAVE, LEVEL_4_LIBRARY, LEVEL_5_SUGAR, LEVEL_6_CLOUD, LEVEL_7_BOSS]

func _ready() -> void:
	music_player.stream = level_music[0]
	music_player.play()

func play_music(level_num) -> void:
	if music_player.stream != level_music[level_num]:
		var tw = create_tween()
		tw.tween_property(music_player, "volume_db", -80, 0.2)
		tw.tween_callback(_change_stream.bind(level_num))
		tw.tween_property(music_player, "volume_db", 0, 0.2)
		


func _change_stream(num:int):
	music_player.stream = level_music[num]
	music_player.play()
