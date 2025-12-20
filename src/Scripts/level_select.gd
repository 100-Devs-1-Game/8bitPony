extends Node2D


func _ready():
	Global.room_tracker = Global.Room.LevelSelect
	
	for door in $Doors.get_children():
		if Global.gem_collected[door.needed_shard]:
			door.set_locked(false)
		else:
			door.set_locked(true)
		
		if Global.gem_collected[Global.Gems.none]:
			$player_start.global_position = $Doors/IntroDoor.global_position
		if Global.gem_collected[Global.Gems.laughter]:
			$player_start.global_position = $Doors/ForestDoor.global_position
		if Global.gem_collected[Global.Gems.loyalty]:
			$player_start.global_position = $Doors/LockedDoor1.global_position
		if Global.gem_collected[Global.Gems.honesty]:
			$player_start.global_position = $Doors/LockedDoor2.global_position
		if Global.gem_collected[Global.Gems.generous]:
			$player_start.global_position = $Doors/LockedDoor3.global_position
		if Global.gem_collected[Global.Gems.kindness]:
			$player_start.global_position = $Doors/LockedDoor4.global_position
		if Global.gem_collected[Global.Gems.magic]:
			$player_start.global_position = $Doors/LockedDoor5.global_position
		if Global.gem_collected[Global.Gems.all]:
			$player_start.global_position = $Doors/LockedDoor5.global_position
