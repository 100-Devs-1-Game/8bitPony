extends Node2D

@export var level_shard_type:Global.Gems

@onready var jail: Area2D = $Jail
@onready var hud: HUD = $HUD


# Called when the node enters the scene tree for the first time.
func _ready():	
	if get_tree().get_node_count_in_group('shards')>0:
		setup_shards()
	else:
		hud.shards_sprite.hide()
	
	jail.set_pony(level_shard_type)
	if Global.pony_saved[level_shard_type]:
		jail.set_open()
	
	
	$Player.health_changed.connect(health_changed)
	$Player.safe_ready()
	

	Music.play_music(level_shard_type+1)

func setup_shards():
	#Create shard array for level if it doesn't exist in Globals
	if Global.collected_shards[level_shard_type].size()==0 and (not Global.gem_collected[level_shard_type] or level_shard_type==Global.Gems.none):
		for temp in get_tree().get_node_count_in_group('shards'):
			Global.collected_shards[level_shard_type].append(false)

	#Remove already collected shards
	var i = 0
	var collected = 0
	for shard in get_tree().get_nodes_in_group('shards'):
		shard.shard_id = i
		shard.shard_type = level_shard_type
		shard.set_color()
		if Global.collected_shards[level_shard_type][shard.shard_id]:
			collected += 1
			shard.queue_free()
		i+=1
	
	#Update shard count in HUD
	Global.current_level_shard = level_shard_type
	#Global.shard_counter = collected
	hud.shards_sprite.set_up_shards()
	hud.level_shards.value = collected
	hud.level_shards.suffix = str("/", i)

func health_changed(health, pony_type):
	hud.update_health(health, pony_type)
	if health[pony_type]<=0:
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://Scenes/Rooms/level_select.tscn")
	

func _on_obj_killbox_body_entered(body):
	if body.is_in_group("Player"):
		body._take_damage() #should run the players damage function
