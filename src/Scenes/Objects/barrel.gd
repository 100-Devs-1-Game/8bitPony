extends Area2D

const SMOKE = preload("uid://bbu116apenly0")
var exploded = false

func _on_body_entered(_body: Node2D) -> void:
	if not exploded:
		exploded = true
		$AnimationPlayer.play("count_down")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name=="count_down":
		var smoke = SMOKE.instantiate()
		smoke.global_position = $Sprite2D.global_position
		var smoke_sprite:AnimatedSprite2D = smoke.get_node("AnimatedSprite2D")
		smoke_sprite.scale *= 1.5
		smoke_sprite.animation = "PegasusLight"
		smoke_sprite.modulate = Color(0.32, 0.0, 0.0, 1.0)
		
		get_tree().current_scene.add_child(smoke)
		
		$AudioStreamPlayer.play()
		$AnimationPlayer.play("broken")
		
		for body in $DamageArea.get_overlapping_bodies():
			body.take_damage()
		
		
