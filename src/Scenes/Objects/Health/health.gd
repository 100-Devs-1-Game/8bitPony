class_name Health
extends Area2D

@export var strength: int = 1

@onready var pick_up: AudioStreamPlayer = $PickUp


func _on_body_entered(body: Node2D) -> void:
	if body is Player and visible:
		body.health_pickup(strength)
		visible = false
		pick_up.play()


func _on_health_finished() -> void:
	queue_free()
