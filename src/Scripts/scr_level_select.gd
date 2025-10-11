extends Node2D

@onready var room_select = $"Room select"
@onready var forest_door_node = $Doors/Forrest_door

var pony_colliding_door: bool = false   # only true when player is inside door area
var at_forest_door: bool = false        # tracks which door

@onready var obj_player = $obj_Player


func _ready():
	Global.roomtracker = Global.rooms.levelselect
	room_select.visible = false   # make sure hidden at startup
	room_select.position.x = 300
	room_select.position.y = 300
	pony_colliding_door = false
	at_forest_door = false

func _process(delta):
	# only show the arrow if colliding
	room_select.visible = pony_colliding_door

func _on_f_door_area_2d_body_entered(body):
	  # check it's actually the player
	if body.is_in_group("player"): 
		room_select.position.x = forest_door_node.position.x + 95
		pony_colliding_door = true
		at_forest_door = true

func _on_f_door_area_2d_body_exited(body):
	room_select.position.x = 300
	pony_colliding_door = false
	at_forest_door = false
	room_select.visible = false

func _input(event):
	# only works if pressing E *and* inside the door
	if Input.is_action_pressed("E") and pony_colliding_door and at_forest_door:
		get_tree().change_scene_to_file("res://Scenes/Rooms/forest_level.tscn")
