extends Area2D

var player_in_area = false
var jail_opened = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact") and player_in_area:
		if not jail_opened:
			$AnimationPlayer.play("open")
			jail_opened = true
			Global.pony_saved[Global.current_level_shard] = true
			await $AnimationPlayer.animation_finished
			get_tree().change_scene_to_file("res://Scenes/Rooms/level_select.tscn")
		else:
			#Im guess some sort of dialog should go here???
			get_tree().change_scene_to_file("res://Scenes/Rooms/level_select.tscn")
	
func set_pony(level_shard):
	$Pony.frame = level_shard

func _on_body_entered(_body: Node2D) -> void:
	player_in_area = true


func _on_body_exited(_body: Node2D) -> void:
	player_in_area = false
		
func set_open(value:bool =true):
	if value:
		jail_opened = true
		$JailBars.hide()
