class_name MagicBullet
extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var lifespan: Timer = $LifeSpan
@onready var explode: AudioStreamPlayer = $Explode

var velocity: int = 2
var exploding: bool = false
var direction:Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("Idle")
	lifespan.start()
	if direction != Vector2.ZERO:
		direction = direction.normalized()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	if not exploding:
		if direction == Vector2.ZERO:
			position.x += velocity
		else:
			position += direction * velocity


func _on_animated_sprite_2d_animation_finished() -> void:
	if exploding:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player or body is Enemy:
		body.take_damage()
	
	exploding = true
	anim.play("Explode")
	explode.play()
	lifespan.stop()
