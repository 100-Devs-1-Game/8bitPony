extends Area2D

var speed = 40
var falling = false


func _physics_process(delta: float) -> void:
	if falling and $AnimationPlayer.current_animation!="die":
		position.y += speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage()
	else:
		die()

func die():
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("die")
	#queue_free called in animation
	
	
func _on_timer_timeout() -> void:
	falling = true
