extends Node2D

@export var room:Global.Room

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.room_tracker = room
	
	#Remove already collected shards
	for shard in get_tree().get_nodes_in_group('shards'):
		if Global.shard_collected[shard.shard_type]:
			shard.queue_free()
	

func _on_obj_killbox_body_entered(body):
	if body.is_in_group("Player"):
		body._take_damage() #should run the players damage function
