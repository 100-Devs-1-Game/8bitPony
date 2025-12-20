extends Area2D

@onready var pick_up: AudioStreamPlayer = $PickUp
@export var shard_type:Global.Shards

func _on_body_entered(body):
	if body is Player and visible:
		visible = false
		pick_up.play()
		Global.pickup_shard(shard_type)


func _on_pick_up_finished():
	queue_free()
