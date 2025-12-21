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
		score_changed.emit()
		
var health:float = 3:
	set(value):
		health = value
		health_changed.emit()


var shard_counter: int = 0:
	set(value):
		shard_counter = value
		shard_value_changed.emit(shard_counter)


# Element Gem trackers
		   #Green,   Red,     Blue,    Yellow,   Pink,     Purple
enum Gems {laughter, loyalty, honesty, generous, kindness, magic, none, all}
var gem_collected = [false, false, false, false, false, false, true, false]

#individual level shards
var collected_shards = [[],
			[],
			[],
			[],
			[],
			[],
			[],[]]

signal shard_value_changed(new_value: int)
signal score_changed(score:int)
signal health_changed(health:float)

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false


func pickup_shard(shard_type, shard_id):
	shard_counter+=1
	collected_shards[shard_type][shard_id] = true
	
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
	
	
	
	
	
