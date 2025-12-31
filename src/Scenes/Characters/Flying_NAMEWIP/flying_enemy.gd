@tool
extends Enemy

@export_enum("blue", "green", "red") var color: String = "blue":
	set(value):
		color = value
		if sprite2D:
			sprite2D.animation= str(color,"_fly")
		
@onready var sprite2D: AnimatedSprite2D = $AnimatedSprite2D
@onready var start_position: Node2D = $start_position

@onready var target:Node2D = start_position
var SPEED = 10


func _ready() -> void:
	sprite2D.animation= str(color,"_fly")
	start_position.global_position = global_position


func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	if global_position.distance_to(target.global_position)> 1:
		var direction = global_position.direction_to(target.global_position)
		velocity = direction*SPEED
	
		if velocity.x > 0: sprite2D.flip_h = false
		else: sprite2D.flip_h = true
	else:
		velocity = Vector2.ZERO
		
	
	move_and_slide()


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body
		$detect.play()
		

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body is Player:
		target = start_position

func _on_hurt_area_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage()
