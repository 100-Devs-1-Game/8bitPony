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
var laughter_gem: bool = false #if collected all the shards
var loyalty_gem: bool = false #if collected all the shards
var honesty_gem: bool = false #if collected all the shards
var generous_gem: bool = false #if collected all the shards
var kindness_gem: bool = false #if collected all the shards
var magic_gem: bool = false #if collected all the shards

signal shard_value_changed(new_value: int)

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
