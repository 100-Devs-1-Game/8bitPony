class_name MagicBullet
extends Area2D

@onready var anim = $AnimatedSprite2D
@onready var timer = $Timer
@onready var lifespan = $LifeSpan

@onready var fire = $Fire
@onready var explode = $Explode

var moving = true
var velocity = 25

# Called when the node enters the scene tree for the first time.
func _ready():
	fire.play()
	anim.play("Idle")
	lifespan.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	if moving == true:
		position.x += velocity

func _on_body_entered(body: Node2D):
	if body is Enemy:
		Global.score += 10
		body.queue_free() #deletes enemy
		anim.play("Explode")
		explode.play()
		moving = false
		timer.start()

func _on_animated_sprite_2d_animation_finished(_Explode):
	pass

func _on_timer_timeout():
	queue_free()


func _on_lifespan_timeout():
#deletes self after 1 second, so bullet doesn't last forever.
	queue_free()
