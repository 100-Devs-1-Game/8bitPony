extends Node2D


func _ready():	
	
	if Global.gem_collected[Global.Gems.none]:
		$Player.global_position = $player_start.global_position
	
	#set door locked/unlocked
	#Show/hide shard cound
	for door in $Doors.get_children():
		#Initialize shard cound visible and door locked/unlocked
		if Global.collected_shards[door.gem_to_collect].size()>0:
			#Move player to the mose recently opened door
			$Player.global_position = door.global_position
			door.set_locked(false)
			if Global.gem_collected[door.gem_to_collect]:
				door.hide_shard_count()
				door.show_gem()
			else:
				door.show_shard_count(Global.collected_shards[door.gem_to_collect].count(true), Global.collected_shards[door.gem_to_collect].size())
		else:
			#If the previous doors gem has been collected, but no shards
			if door.gem_to_collect==Global.Gems.laughter or Global.gem_collected[door.gem_to_collect-1]:
				door.set_locked(false)
			else:
				door.set_locked(true)
	
	
	#unlock all doors for debug
	for door in $Doors.get_children():
		door.set_locked(false)

	
	#Set gems visible in "gem holde"
	if Global.gem_collected[Global.Gems.laughter]: $CanvasLayer/Element_Harmony/green.show()
	else: $CanvasLayer/Element_Harmony/green.hide()
	
	if Global.gem_collected[Global.Gems.loyalty]: $CanvasLayer/Element_Harmony/red.show()
	else: $CanvasLayer/Element_Harmony/red.hide()
	
	if Global.gem_collected[Global.Gems.honesty]: $CanvasLayer/Element_Harmony/blue.show()
	else: $CanvasLayer/Element_Harmony/blue.hide()
	
	if Global.gem_collected[Global.Gems.generous]: $CanvasLayer/Element_Harmony/yellow.show()
	else: $CanvasLayer/Element_Harmony/yellow.hide()
	
	if Global.gem_collected[Global.Gems.kindness]: $CanvasLayer/Element_Harmony/pink.show()
	else: $CanvasLayer/Element_Harmony/pink.hide()
	
	if Global.gem_collected[Global.Gems.magic]: $CanvasLayer/Element_Harmony/purple.show()
	else: $CanvasLayer/Element_Harmony/purple.hide()
