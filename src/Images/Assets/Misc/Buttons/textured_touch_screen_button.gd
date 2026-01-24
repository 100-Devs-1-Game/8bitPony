@tool
extends TouchScreenButton
class_name TexturedTouchScreenButton

@export var texture: Texture2D:
	set(value):
		texture = value
		_update()
@export var button_size: Vector2i = Vector2i(16, 16):
	set(value):
		button_size = value
		_update()
@export var normal_texture_index: int = 0:
	set(value):
		normal_texture_index = value
		_update()
@export var pressed_texture_index: int = 1:
	set(value):
		pressed_texture_index = value
		_update()


func _get_texture_rect(index: int) -> ImageTexture:
	if texture:
		var texture_size: Vector2i = texture.get_size()
		var rows: int = int(float(texture_size.x) / button_size.x)
		var rect: Rect2 = Rect2(
			Vector2(
				(index % rows) * button_size.x,
				int(float(index) / rows) * button_size.y
			),
			button_size
		)
		var image_rect: Image = texture.get_image().get_region(rect)
		var image_texture: ImageTexture = ImageTexture.create_from_image(image_rect)
		return image_texture
	return null

func _update():
	texture_normal = _get_texture_rect(normal_texture_index)
	texture_pressed = _get_texture_rect(pressed_texture_index)
