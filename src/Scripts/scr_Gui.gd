extends CanvasLayer

@onready var gui_1 = $Gui1
@onready var score = $Gui1/Score
@onready var level_shards = $Gui1/Level_Shards
@onready var Lives = $Gui1/Lives 

func _pause():
	#pausing game, but can't unpause :(
	if get_tree().paused == false:
		if Input.is_action_just_released("Pause"): 
			get_tree().paused = true
			return
	else:
		get_tree().paused = false
		return


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	score.text = "Score: " + str(Global.score)
	level_shards.text = str(Global.shard_counter) + "/7"
	Lives.text = "Lives: " + str(Global.player_lives)
	
	#disables the specific level gui
	if Global.roomtracker == Global.rooms.Mainmenu:
		gui_1.visible = false	
	elif Global.roomtracker == Global.rooms.levelselect:
		gui_1.visible = false
	else:
		gui_1.visible = true
	
func _input(event): #reset scene
	if Input.is_action_just_pressed("R"):
		get_tree().reload_current_scene()
