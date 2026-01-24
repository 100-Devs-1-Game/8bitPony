@tool
extends TexturedTouchScreenButton
class_name PonyTypeTexturedTouchScreenButton

const PonyType = Global.PonyType

@export var pony_type_normal_texture: Dictionary[PonyType, int]
@export var pony_type_pressed_texture: Dictionary[PonyType, int]
@export var earth_pony_on_floor_offset: bool = false

var was_on_floor: bool = true

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
	if earth_pony_on_floor_offset:
		match new_pony_type:
			PonyType.Earth:
				was_on_floor = true
				_handle_earth_pony_on_floor(Global.player.is_on_floor())
				Global.player.on_earth_pony_on_floor.connect(_handle_earth_pony_on_floor)
			_:
				Global.player.on_earth_pony_on_floor.disconnect(_handle_earth_pony_on_floor)
	_update()

func _handle_earth_pony_on_floor(is_on_floor: bool):
	if was_on_floor != is_on_floor:
		was_on_floor = is_on_floor
		if is_on_floor:
			normal_texture_index -= 1
			pressed_texture_index -= 1
		else:
			normal_texture_index += 1
			pressed_texture_index += 1
