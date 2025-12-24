extends Area2D


func _on_body_entered(body: Node2D):
	body.take_damage(999)
