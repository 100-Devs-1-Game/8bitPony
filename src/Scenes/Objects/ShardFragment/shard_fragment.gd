extends Area2D

@onready var pick_up: AudioStreamPlayer = $PickUp
var shard_type:Global.Gems
var shard_id:int = 0

func _on_body_entered(body):
	if body is Player and visible:
		visible = false
		pick_up.play()
		Global.pickup_shard(shard_type, shard_id)

func set_color():
	$Sprite2D.frame = shard_type

func _on_pick_up_finished():
	queue_free()
