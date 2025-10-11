class_name Wolf
extends CharacterBody2D

@onready var texture_rect: TextureRect = $TextureRect
@onready var ray_cast_right: RayCast2D = $RayCast_Right
@onready var ray_cast_left: RayCast2D = $RayCast_Left

@export var speed: float = 300

var direction: int = 1


func _process(_delta: float):
	if ray_cast_right.is_colliding():
		direction = -1
		texture_rect.flip_h = false
	if ray_cast_left.is_colliding():
		direction = 1
		texture_rect.flip_h = true
	position.x += direction * speed * _delta


func _on_enemy_hitbox_body_entered(body):
	if body.is_in_group("Player"):
		body._take_damage() #should run the players damage function
		queue_free() #deletes self
