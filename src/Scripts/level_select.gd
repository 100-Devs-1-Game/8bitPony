extends Node2D


func _ready():
	Global.room_tracker = Global.Room.LevelSelect
	
	for door in $Doors.get_children():
		if Global.shard_collected[door.needed_shard]:
			door.set_locked(false)
		else:
			door.set_locked(true)
