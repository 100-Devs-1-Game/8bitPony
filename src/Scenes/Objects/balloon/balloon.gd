@tool
extends AnimatableBody2D



@export_enum("Red", "Blue", "Yellow") var color: int:
	set(value):
		color = value
		print(color)
		$Sprite2D.frame = color
