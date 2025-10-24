extends CanvasLayer

@onready var gui: Control = $Gui
@onready var score: Label = $Gui/Score
@onready var level_shards: Label = $Gui/LevelShards
@onready var lives: Label = $Gui/Lives 

func _pause():
	get_tree().paused = not get_tree().paused

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
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Respawn"):
		get_tree().reload_current_scene()
