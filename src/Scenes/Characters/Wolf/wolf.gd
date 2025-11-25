class_name Wolf
extends Enemy

@onready var sprite: Sprite2D = $Sprite2D
@onready var ray_cast_right: RayCast2D = $RayCast_Right
@onready var ray_cast_left: RayCast2D = $RayCast_Left

@export var speed: float = 300

var direction: int = 1


func _process(delta: float):
	if ray_cast_right.is_colliding():
		direction = -1
		sprite.flip_h = false
	if ray_cast_left.is_colliding():
		direction = 1
		sprite.flip_h = true
	velocity.x = direction * speed * delta
	move_and_slide()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage()
