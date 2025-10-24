extends Node2D

@onready var room_select: Node2D = $"RoomSelect"


func _ready():
	Global.room_tracker = Global.Room.LevelSelect
