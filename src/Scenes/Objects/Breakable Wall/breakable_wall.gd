extends StaticBody2D

var has_player:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(_delta: float) -> void:
	if has_player:
		if Global.player.get_pony_type_as_string()=="Earth" and Global.player.has_state_action():
			$AudioStreamPlayer.play()
			$Sprite2D.hide()
			$CollisionShape2D.set_deferred("disabled", true)
			
			await $AudioStreamPlayer.finished
			queue_free()


func _on_player_detector_body_entered(_player: Node2D) -> void:
	has_player = true

func _on_player_detector_body_exited(_body: Node2D) -> void:
	has_player = false
