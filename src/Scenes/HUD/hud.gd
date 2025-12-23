extends CanvasLayer

@onready var score: ValueLabel = $Gui/Stats/ScoreValue
@onready var level_shards: ValueLabel = $Gui/Stats/Shards/ShardValue
@onready var hearts: TextureRect = $Hearts

#Earth, Pegasus, Unicorn, Max
var heart_colors = [Color.html("#82ff84"), Color.html("52daf3"), Color.html("#ff82fd")]

func _ready() -> void:
	score.value = Global.score
	Global.score_changed.connect(_on_score_changed)
	


func _on_score_changed(new_score: int):
	score.value = new_score

func update_health(health, pony_type):
	print("here")
	hearts.modulate = heart_colors[pony_type]
	hearts.size.x = health[pony_type]*16
