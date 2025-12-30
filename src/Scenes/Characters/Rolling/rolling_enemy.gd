extends CharacterBody2D

#Set by boulder spawner
var roll_direction = "left"
var sprite_type = "log"

var gravity: float = 50
var direction = -1
var speed = 30
var time_alive = 0
var roll_angle = 0
@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	if roll_direction=="right":
		direction = 1
		$detect__wall.rotation_degrees = 180
	
	if sprite_type=="boulder":
		sprite.frame = 1
	elif sprite_type=="cookie":
		sprite.frame = 2


func _physics_process(delta: float) -> void:
	time_alive += delta
	if is_on_floor():
		velocity.x = direction * speed
		roll_angle += 100*direction*delta
		if roll_angle>360: roll_angle -=360
		elif roll_angle<0: roll_angle +=360
		
		sprite.rotation_degrees = int(roll_angle/45)*90
		
		#if roll_angle <= 90: sprite.rotation_degrees = 0
		#elif roll_angle <= 180: sprite.rotation_degrees = 90
		#elif roll_angle <= 270: sprite.rotation_degrees = 180
		#elif roll_angle <= 360: sprite.rotation_degrees = 270
	else:
		velocity.x = 0
		velocity.y = gravity
		
	
	move_and_slide()
	
	if time_alive > 30:
		queue_free()



func _on_hurt_area_body_entered(body: Node2D) -> void:
	body.take_damage()


func _on_detect__wall_body_entered(_body: Node2D) -> void:
	queue_free()

func take_damage():
	queue_free()
