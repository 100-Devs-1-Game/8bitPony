extends Enemy

@export_enum("blue", "green", "red") var color: String = "blue"
@onready var sprite2D: AnimatedSprite2D = $AnimatedSprite2D
@onready var start_position: Node2D = $start_position

@onready var target:Node2D = start_position
var SPEED = 10


func _ready() -> void:
	start_position.global_position = global_position
	print(str(color,"_fly"))
	sprite2D.animation= str(color,"_fly")


func _physics_process(_delta: float) -> void:
	if global_position.distance_to(target.global_position)> 0.5:
		var direction = global_position.direction_to(target.global_position)
		velocity = direction*SPEED

		move_and_slide()


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body
		

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body is Player:
		target = start_position

func _on_hurt_area_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage()
