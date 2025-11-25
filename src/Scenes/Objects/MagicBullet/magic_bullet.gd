class_name MagicBullet
extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var lifespan: Timer = $LifeSpan
@onready var explode: AudioStreamPlayer = $Explode

var velocity: int = 25
var exploding: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("Idle")
	lifespan.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	if not exploding:
		position.x += velocity


func _on_lifespan_timeout():
	queue_free()


func _on_animated_sprite_2d_animation_finished() -> void:
	if exploding:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		Global.root.player.score += 10
		exploding = true
		body.take_damage()
		anim.play("Explode")
		explode.play()
		lifespan.stop()
