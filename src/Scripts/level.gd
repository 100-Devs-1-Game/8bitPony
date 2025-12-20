extends Node2D

@export var room:Global.Room
@export var level_shard_type:Global.Gems

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.room_tracker = room
	
	if Global.collected_shards[level_shard_type].size()==0 and (not Global.gem_collected[level_shard_type] or level_shard_type==Global.Gems.none):
		for temp in get_tree().get_node_count_in_group('shards'):
			Global.collected_shards[level_shard_type].append(false)
	
	
	var i = 0
	var collected = 0
	#Remove already collected shards
	for shard in get_tree().get_nodes_in_group('shards'):
		shard.shard_id = i
		shard.shard_type = level_shard_type
		if Global.collected_shards[level_shard_type][shard.shard_id]:
			collected += 1
			shard.queue_free()
		i+=1
	
	Global.shard_counter = collected
		
	#Update shard count in HUD
	$HUD.level_shards.value = collected
	$HUD.level_shards.suffix = str("/", i)


func _on_obj_killbox_body_entered(body):
	if body.is_in_group("Player"):
		body._take_damage() #should run the players damage function
