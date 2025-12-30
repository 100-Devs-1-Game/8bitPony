@tool
extends AnimatableBody2D



@export_enum("Red", "Blue", "Yellow") var color: int:
	set(value):
		color = value
		$Sprite2D.frame = color


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.make_jump()
