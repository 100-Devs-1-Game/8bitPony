extends CanvasLayer

@onready var gui: Control = $Gui
@onready var score: Label = $Gui/Score
@onready var level_shards: Label = $Gui/LevelShards
@onready var lives: Label = $Gui/Lives 

func _pause():
	#pausing game, but can't unpause :(
	if not get_tree().paused:
		if Input.is_action_just_released("Pause"): 
			get_tree().paused = true
			return
	else:
		get_tree().paused = false
		return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float):
	score.text = "Score: " + str(Global.score)
	level_shards.text = str(Global.shard_counter) + "/7"
	lives.text = "Lives: " + str(Global.player_lives)
	
	#disables the specific level gui
	if Global.room_tracker == Global.Room.MainMenu:
		gui.visible = false	
	elif Global.room_tracker == Global.Room.LevelSelect:
		gui.visible = false
	else:
		gui.visible = true
	
func _input(_event: InputEvent): #reset scene
	if Input.is_action_just_pressed("Respawn"):
		get_tree().reload_current_scene()
