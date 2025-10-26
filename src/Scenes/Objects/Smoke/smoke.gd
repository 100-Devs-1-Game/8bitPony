extends Node2D

@export var speed: float = 200.0
@export var end_scale: float = 5.0
@export var end_alpha: float = 0

@onready var lifespan: Timer = $Lifespan
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var start_scale: float


func _ready() -> void:
	start_scale = scale.x


func _physics_process(delta: float) -> void:
	global_position.y -= speed * delta
	var lerp_value: float = (lifespan.wait_time - lifespan.time_left) / lifespan.wait_time
	var scale_value = lerp(start_scale, end_scale, lerp_value)
	scale = Vector2(scale_value, scale_value)
	sprite.modulate.a = lerp(1.0, end_alpha, lerp_value)


func _on_lifespan_timeout() -> void:
	queue_free()


func _on_rotation_timeout() -> void:
	rotate(deg_to_rad(90))
