extends Enemy

@export var sprite: Texture2D
@onready var sprite_node: Sprite2D = $Sprite2D

##Handle this in global coordinates
@export var idle_position: Vector2 = Vector2.ZERO

@onready var detection_area: Area2D = $detection_area

func _ready() -> void:
	sprite_node.texture = sprite

func _physics_process(delta: float) -> void:
	var tracking: bool = false
	for node in detection_area.get_overlapping_bodies():
		if node is Player and idle_position.distance_squared_to(node.position) < 512**2: 
			velocity = global_position.direction_to(node.position) * 300.0
			tracking = true
	
	if !tracking and position.distance_squared_to(idle_position) > 128**2:
		velocity = global_position.direction_to(idle_position)
	
	move_and_slide()
