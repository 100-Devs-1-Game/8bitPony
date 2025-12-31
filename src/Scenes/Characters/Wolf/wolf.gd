class_name Wolf
extends Enemy

@onready var sprite:= $Sprite2D
@onready var ray_cast_right: RayCast2D = $RayCast_Right
@onready var ray_cast_left: RayCast2D = $RayCast_Left

@export var speed: float = 40

var direction: int = -1

var sound_timer = 1
var sound_time = 0


func _physics_process(_delta: float) -> void:
	#sound_timer-= _delta
	#if sound_timer<=0:
		#print("here")
		#$AudioStreamPlayer2D.pitch_scale = randf_range(0.8, 1.2)
		#$AudioStreamPlayer2D.play()
		#sound_timer = sound_time
	
	if ray_cast_right.is_colliding() or ray_cast_left.is_colliding():
		flip_direction()
		
	velocity.x = direction * speed
	move_and_slide()


func _on_body_entered(body: Node2D) -> void:
	body.take_damage()


func _on_detect_floor_body_exited(_body: Node2D) -> void:
	flip_direction()

func flip_direction():
	direction *= -1
	sprite.flip_h = !sprite.flip_h
