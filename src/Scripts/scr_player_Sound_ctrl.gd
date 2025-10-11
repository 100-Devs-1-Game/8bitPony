extends Node2D

@onready var shoot_sound = $"../Shoot_sound"
@onready var land_sound = $"../Land_sound"



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if Input.is_action_just_pressed("Shoot"):
		shoot_sound.play()
