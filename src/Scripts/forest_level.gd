extends Node2D

@onready var player: Player = $Player
@onready var player_startpos = $Player_Startpos
@onready var camera: Camera2D = $Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.room_tracker = Global.Room.Forest

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	if player.position.x >= 640:
		camera.position.x = player.position.x + 100
	if camera.position.y <= 600: 
		camera.position.y = player.position.y -150
	else:
		camera.position = camera.position

func _on_obj_killbox_body_entered(body):
	if body.is_in_group("Player"):
		body._take_damage() #should run the players damage function
		#Camera and player position reset
		camera.position_smoothing_enabled = false
		await get_tree().create_timer(0.5).timeout
		player.position = player_startpos.position
		camera.position = player_startpos.position
		await get_tree().create_timer(0.5).timeout
		camera.position_smoothing_enabled = true
