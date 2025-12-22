extends CanvasLayer

@onready var score: ValueLabel = $Gui/Stats/ScoreValue
@onready var level_shards: ValueLabel = $Gui/Stats/Shards/ShardValue
@onready var health: ValueLabel = $Gui/HealthValue


func _ready() -> void:
	score.value = Global.score
	
	health.value = Global.health
	Global.health_changed.connect(_on_health_changed)
	
	Global.score_changed.connect(_on_score_changed)
	Global.shard_value_changed.connect(_on_shard_changed)
	



func _on_score_changed(new_score: int):
	score.value = new_score


func _on_shard_changed():
	#level_shards.value = new_value
	pass

func _on_health_changed(new_health: int):
	health.value = new_health
