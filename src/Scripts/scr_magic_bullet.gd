extends Area2D

@onready var anim = $AnimatedSprite2D
var moving = true
@onready var timer = $Timer
@onready var timer_2 = $Timer2

@onready var fire = $Fire
@onready var explode = $Explode

var face_right = true

# Called when the node enters the scene tree for the first time.
func _ready():
	fire.play()
	
	anim.play("Idle")
	timer_2.start()
	if Global.face_right == true:
		face_right = true
	else:
		face_right = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moving == true:
		if face_right == true:
			position.x += 25
		else:
			position.x -= 25
	else:
		position.x = position.x

func _on_body_entered(body):
	Global.score += 10
	body.queue_free() #deletes enemy
	anim.play("Explode")
	explode.play()
	
	
	moving = false
	timer.start()
func _on_animated_sprite_2d_animation_finished(Explode):
	pass


func _on_timer_timeout():
	queue_free()


func _on_timer_2_timeout():
#deletes self after 1 second, so bullet doesn't last forever.
	queue_free()
