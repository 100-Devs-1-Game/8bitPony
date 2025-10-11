extends Node2D
@onready var obj_player = $obj_Player
@onready var player_startpos = $Player_Startpos
@onready var camera_2d = $Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.roomtracker = Global.rooms.Forest


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if obj_player.position.x >= 640:
		camera_2d.position.x = obj_player.position.x + 100
	if camera_2d.position.y <= 600: 
		camera_2d.position.y = obj_player.position.y -150
	else:
		camera_2d.position = camera_2d.position
		
		
func _on_obj_killbox_body_entered(body):
	if body.is_in_group("Player"):
		body._take_damage() #should run the players damage function
		#Camera and player position reset
		camera_2d.position_smoothing_enabled = false
		await get_tree().create_timer(0.5).timeout
		obj_player.position = player_startpos.position
		camera_2d.position = player_startpos.position
		await get_tree().create_timer(0.5).timeout
		camera_2d.position_smoothing_enabled = true
