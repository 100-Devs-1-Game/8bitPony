extends CharacterBody2D

#Set by boulder spawner
var roll_direction = "left"
var sprite_type = "boulder"

var gravity: float = 50
var direction = -1
var speed = 30

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	if roll_direction=="right":
		direction = 1
		$detect__wall.rotation_degrees = 180
		
	if sprite_type=="cookie":
		sprite.frame = 1


func _physics_process(delta: float) -> void:
	
	if is_on_floor():
		velocity.x = direction * speed
		sprite.rotation_degrees += 100*direction*delta
		if sprite.rotation_degrees>360: sprite.rotation_degrees -=360
		elif sprite.rotation_degrees<0: sprite.rotation_degrees +=360
	else:
		velocity.y = gravity
		
	
	move_and_slide()



func _on_hurt_area_body_entered(body: Node2D) -> void:
	body.take_damage()


func _on_detect__wall_body_entered(body: Node2D) -> void:
	print("Run into a wall...break")
	queue_free()
