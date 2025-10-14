extends Node

enum Room {MainMenu, LevelSelect, Forest}

var score: int = 0
var shard_counter: int = 0
var room_tracker: Room = Room.MainMenu

# Element Gem trackers
var laughter_gem: bool = false #if collected all the shards
var loyalty_gem: bool = false #if collected all the shards
var honesty_gem: bool = false #if collected all the shards
var generous_gem: bool = false #if collected all the shards
var kindness_gem: bool = false #if collected all the shards
var magic_gem: bool = false #if collected all the shards

#Player lives
var player_lives: int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
