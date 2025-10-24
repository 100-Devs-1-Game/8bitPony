class_name Door
extends Sprite2D

@export var is_locked: bool = true
@export var target_scene: PackedScene

@onready var lock_sprite: Sprite2D = $Lock
@onready var tool_tip: Node2D = $ToolTip

var player_on_door: bool = false

func _ready() -> void:
	set_locked(is_locked)


func set_locked(locked: bool):
	is_locked = locked
	lock_sprite.visible = locked


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player_on_door = true
		tool_tip.visible = not is_locked


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		player_on_door = false
		tool_tip.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact") and player_on_door and not is_locked:
		get_tree().change_scene_to_packed(target_scene)
