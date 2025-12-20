extends Enemy



@export var level:Global.Room
@onready var sprite2D: AnimatedSprite2D = $AnimatedSprite2D
@onready var start_position: Node2D = $start_position

@onready var target:Node2D = start_position
var SPEED = 5


func _ready() -> void:
	start_position.global_position = global_position
	if level==Global.Room.Forest:
		sprite2D.animation= "forest_fly"
	#TODO: Put other level names here to auto change fly sprite

func _physics_process(_delta: float) -> void:
	print(global_position.distance_to(target.global_position))
	if global_position.distance_to(target.global_position)> 0.5:
		var direction = global_position.direction_to(target.global_position)
		velocity = direction*SPEED
		
		
		#var tracking: bool = false
		#for node in detection_area.get_overlapping_bodies():
			#if node is Player and idle_position.distance_squared_to(node.position) < 512**2: 
				#velocity = global_position.direction_to(node.position) * 300.0
				#tracking = true
		#
		#if !tracking and position.distance_squared_to(idle_position) > 128**2:
			#velocity = global_position.direction_to(idle_position)
		
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
