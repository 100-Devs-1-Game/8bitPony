extends Area2D

@onready var pick_up: AudioStreamPlayer = $PickUp


func _on_body_entered(body):
	if body is Player and visible:
		visible = false
		pick_up.play()
		Global.shard_counter += 1


func _on_pick_up_finished():
	queue_free()
