extends Area2D
@onready var pick_up = $Pick_up
var collide = false
@onready var texture_rect = $TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	texture_rect.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if collide == false:
		if body.is_in_group("Player"):
			collide = true
			texture_rect.visible = false
			pick_up.play()
			Global.shard_counter += 1
	
		return
	
func _on_pick_up_finished():
	queue_free()
