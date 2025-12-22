extends Sprite2D

var total_shards = 0
var collected_shards = 0
var start_shard_rotation = 0

const HUD_SHARD = preload("uid://b53ev8idqwxbo")

func _ready():
	Global.shard_value_changed.connect(add_shard)
	
	

func set_up_shards():
	#If is for debugging/test levels
	if Global.current_level_shard<6:
		frame = Global.current_level_shard
		
	total_shards = Global.collected_shards[Global.current_level_shard].size()
	var temp = Global.collected_shards[Global.current_level_shard].count(true)
	
	if temp<total_shards:
		for i in range(temp):
			add_shard()
	else:
		self_modulate = Color(1.0, 1.0, 1.0, 1.0)

func _physics_process(delta: float) -> void:
	start_shard_rotation +=36*delta
	if start_shard_rotation>=360: start_shard_rotation -=360
	for shard in get_children():
		#Rotate shard around center
		shard.rotation_degrees += 36*delta
		if shard.rotation_degrees >=360: shard.rotation_degrees -=360
		
		#Counter rotate sprite to keep it uprite
		shard.get_node("shard").rotation_degrees = -1*shard.rotation_degrees

func add_shard():
	collected_shards +=1
	var angle = (360/total_shards)*collected_shards

	var new_shard = HUD_SHARD.instantiate()
	new_shard.position = Vector2.ZERO
	new_shard.rotation_degrees = start_shard_rotation+angle
	
	#If needed for debug/test levels
	if Global.current_level_shard<6:
		new_shard.get_node("shard").frame = Global.current_level_shard
	add_child(new_shard)
	
	if collected_shards==total_shards:
		var tw = create_tween().set_parallel()
		
		for shard in get_children():
			tw.tween_property(shard, "scale", Vector2.ZERO, 0.5)
		tw.chain().tween_property(self, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), 1)
