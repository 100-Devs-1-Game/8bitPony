extends Area2D


func _on_body_entered(body: Node2D):
	print(body)
	if body.has_method("take_damage"):
		body.take_damage()
		body.global_position = global_position


#func _on_area_entered(area: Area2D) -> void:
	#if area.has_method("take_damage"):
		#area.take_damage()
