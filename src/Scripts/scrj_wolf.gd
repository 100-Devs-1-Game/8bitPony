extends CharacterBody2D

@onready var texture_rect = $TextureRect
const SPEED = 300

var direction = 1

@onready var ray_cast_right = $RayCast_Right
@onready var ray_cast_left = $RayCast_Left


func _process(delta):
	if ray_cast_right.is_colliding():
		direction = -1
		texture_rect.flip_h = false
	if ray_cast_left.is_colliding():
		direction = 1
		texture_rect.flip_h = true
	position.x += direction * SPEED * delta

func _on_animation_player_animation_finished(anim_name):
	pass


func _on_enemy_hitbox_body_entered(body):
	if body.is_in_group("Player"):
		body._take_damage() #should run the players damage function
		queue_free() #deletes self
