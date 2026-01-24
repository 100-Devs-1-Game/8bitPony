@tool
extends TexturedTouchScreenButton
class_name PonyTypeTexturedTouchScreenButton

const PonyType = Global.PonyType

@export var pony_type_normal_texture: Dictionary[PonyType, int]
@export var pony_type_pressed_texture: Dictionary[PonyType, int]


func _ready() -> void:
	if not Engine.is_editor_hint():
		var player: Player = Global.player
		if player:
			_handle_player_ready(player)
		else:
			Global.on_player_ready.connect(_handle_player_ready)

func _handle_player_ready(player: Player):
	_handle_pony_type_changed(player.pony_type)
	player.on_pony_type_changed.connect(_handle_pony_type_changed)

func _handle_pony_type_changed(new_pony_type: PonyType):
	if pony_type_normal_texture.has(new_pony_type):
		normal_texture_index = pony_type_normal_texture[new_pony_type]
	if pony_type_pressed_texture.has(new_pony_type):
		pressed_texture_index = pony_type_pressed_texture[new_pony_type]
	_update()
