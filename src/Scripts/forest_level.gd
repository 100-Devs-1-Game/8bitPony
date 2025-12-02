extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.room_tracker = Global.Room.Forest

func _on_obj_killbox_body_entered(body):
	if body.is_in_group("Player"):
		body._take_damage() #should run the players damage function
