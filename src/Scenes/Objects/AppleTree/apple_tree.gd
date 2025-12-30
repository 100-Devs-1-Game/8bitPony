extends Node2D


const APPLE = preload("uid://d0q1h4c4mgcb6")

func _ready() -> void:
	$Timer.start(randi_range(1, 3))


func _on_timer_timeout() -> void:
	var a = APPLE.instantiate()
	a.position = $Top.position + Vector2(randi_range(-10, 10), randi_range(-10, 10))
	add_child(a)
	
	$Timer.start(randi_range(1, 3))
