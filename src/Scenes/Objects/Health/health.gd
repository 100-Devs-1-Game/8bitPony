class_name Health
extends Area2D

@export var strength: int = 1


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.health_pickup(strength)
		queue_free()
