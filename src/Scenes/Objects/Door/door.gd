@tool

class_name Door
extends Area2D


@export var is_locked: bool = true
@export_file ("*.tscn") var target_scene:String
@export var gem_to_collect:Global.Gems = Global.Gems.none:
	set(value):
		gem_to_collect = value
		if gem_to_collect < Global.Gems.none:
			$Shard.frame = gem_to_collect
		else:
			$Shard.frame = 0
	
@onready var name_label: Label = $NameLabel

@onready var lock_sprite: Sprite2D = $Sprite2D/Lock
@onready var tool_tip: Node2D = $ToolTip

var player_on_door: bool = false
var level_shards = 0

func _ready() -> void:
	set_locked(is_locked)
	if gem_to_collect<6:
		$Gem.frame = gem_to_collect
	

func set_locked(locked: bool):
	is_locked = locked
	lock_sprite.visible = locked

func hide_shard_count():
	$Shard.hide()
	$ShardLabel.hide()

func show_shard_count(collected, total):
	$ShardLabel.text = str(collected,"/",total)
	$Shard.show()
	$ShardLabel.show()

func show_gem():
	$Gem.show()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact") and player_on_door and not is_locked:
		get_tree().change_scene_to_file(target_scene)


func _on_body_entered(body: Node2D) -> void:
	if body is Player and not is_locked:
		player_on_door = true
		tool_tip.visible = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_on_door = false
		tool_tip.visible = false
