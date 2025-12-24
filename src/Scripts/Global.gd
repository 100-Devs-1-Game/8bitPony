extends Node

enum Level {Forest, Apple, Cave, Library, Sugar, Cloud}

var root: Root:
	set(new_root):
		root = new_root
		
var player: Player
var current_form:int = 2 #Unicorn

var scene: Node
var score:int = 0:
	set(value):
		score = value
		score_changed.emit(score)
		
var health:float = 3:
	set(value):
		health = value
		health_changed.emit()

# Element Gem trackers
		   #Green,   Red,     Blue,    Yellow,   Pink,     Purple
enum Gems {laughter, loyalty, honesty, generous, kindness, magic, none, all, test1, test2}
var gem_collected = [false, false, false, false, false, false, true, false, false, false]

var pony_saved = [false, false, false, false, false, false, false, false, false, false]
var current_level_shard = Gems.laughter

#individual level shards
var collected_shards = [[],[],[],[],[],[],[],[],[],[]]

signal shard_value_changed()
signal score_changed(score:int)
signal health_changed(health:float)

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false


func pickup_shard(shard_type, shard_id):
	collected_shards[shard_type][shard_id] = true
	
	shard_value_changed.emit()
	
	#If you collected all shards, set collected gem= true
	if false not in collected_shards[shard_type]:
		gem_collected[shard_type] = true
		
		var all_gems = true
		for i in range(gem_collected.size()-2):
			if gem_collected[i]==false:
				all_gems=false
				break

		if all_gems:
			gem_collected[Gems.all] = true
	
