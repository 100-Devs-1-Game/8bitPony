extends Area2D

const CHANDLIER = preload("uid://4h8a50dpnn77")

var current_stag
@export var allow_falling = true

func _ready() -> void:
	spawn_stalactite()
	

func _on_body_entered(_body: Node2D) -> void:
	$drop_timer.start()


func _on_drop_timer_timeout() -> void:
	if allow_falling:
		current_stag.fall()
		$spawn_timer.start()
	$CollisionShape2D.set_deferred("disabled", true)


func _on_spawn_timer_timeout() -> void:
	spawn_stalactite()

func spawn_stalactite():
	var new_stag = CHANDLIER.instantiate()
	new_stag.position = Vector2.ZERO
	current_stag = new_stag
	add_child(new_stag)
	$CollisionShape2D.set_deferred("disabled", false)
