extends Node

enum Room {MainMenu, LevelSelect, Forest}

var root: Root:
	set(new_root):
		root = new_root
		player = root.player
var player: Player
var scene: Node
var shard_counter: int = 0:
	set(value):
		shard_counter = value
		shard_value_changed.emit(shard_counter)
var room_tracker: Room = Room.MainMenu

# Element Gem trackers
enum Shards {laughter, loyalty, honesty, generous, kindness, magic, none}
var shard_collected = [false, false, false, false, false, false, true]

signal shard_value_changed(new_value: int)

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false

func pickup_shard(shard_type):
	shard_collected[shard_type] = true
	shard_counter+=1
