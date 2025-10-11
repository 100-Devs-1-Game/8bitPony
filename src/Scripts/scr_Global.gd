extends Node

var score = 0
var shard_counter = 0
enum rooms {Mainmenu, levelselect, Forest}
var roomtracker = rooms

# Element Gem trackers
var Laughter_Gem = false #if collected all the shards
var Loyalty_Gem = false #if collected all the shards
var Honesty_Gem = false #if collected all the shards
var Generous_Gem = false #if collected all the shards
var Kindness_Gem = false #if collected all the shards
var Magic_Gem = false #if collected all the shards

#Direction facing track
var face_right = true
var face_left = false

#Player lives
var player_lives: int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	roomtracker = rooms.Mainmenu
	

# Called every frame. 'delta' is the elapsed time since the previous frame.



func _input(event):
	pass
