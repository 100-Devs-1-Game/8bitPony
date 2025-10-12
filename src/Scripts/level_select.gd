extends Node2D

@onready var room_select: Node2D = $"RoomSelect"
@onready var forest_door_node: TextureRect = $Doors/ForestDoor

var pony_colliding_door: bool = false   # only true when player is inside door area
var at_forest_door: bool = false        # tracks which door


func _ready():
	Global.room_tracker = Global.Room.LevelSelect
	room_select.visible = false   # make sure hidden at startup
	room_select.position.x = 300
	room_select.position.y = 300
	pony_colliding_door = false
	at_forest_door = false

func _process(_delta: float):
	# only show the arrow if colliding
	room_select.visible = pony_colliding_door

func _on_f_door_area_2d_body_entered(_body: Node2D):
	# check it's actually the player
	if _body.is_in_group("player"): 
		room_select.position.x = forest_door_node.position.x + 95
		pony_colliding_door = true
		at_forest_door = true

func _on_f_door_area_2d_body_exited(_body: Node2D):
	room_select.position.x = 300
	pony_colliding_door = false
	at_forest_door = false
	room_select.visible = false

func _input(_event: InputEvent):
	# only works if pressing E *and* inside the door
	if Input.is_action_pressed("Interact") and pony_colliding_door and at_forest_door:
		get_tree().change_scene_to_file("res://Scenes/Rooms/forest_level.tscn")
