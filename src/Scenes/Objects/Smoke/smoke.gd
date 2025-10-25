extends Node2D

@export var speed: float = 200.0
@export var scale_factor: float = 0.99


func _physics_process(delta: float) -> void:
	global_position.y -= speed * delta
	scale *= scale_factor


func _on_lifespan_timeout() -> void:
	queue_free()


func _on_rotation_timeout() -> void:
	rotate(deg_to_rad(90))
